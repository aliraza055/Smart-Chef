import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_chef/Models/food_anlysis_model.dart';

/// Jab Gemini teeno retries ke baad bhi fail ho jaye (rate limit,
/// server overload, ya network down), ye specific exception throw
/// hoti hai. Controller isko catch karke user ko manual-search
/// (Open Food Facts) option dikhata hai — generic Exception se is
/// case ko alag rakhna zaroori hai taake UI sahi decide kar sake.
class GeminiUnavailableException implements Exception {
  final String message;
  GeminiUnavailableException(this.message);
  @override
  String toString() => message;
}

class AiServiceImage {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-3.5:generateContent';

  static const String _cachePrefix = 'food_analysis_cache_';

  static Future<FoodAnalysis> analyzeFoodImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();

    // ── STEP 1: Cache check ──────────────────────────────────────
    // Same image dobara scan ho (user galti se ya jaan-boojh kar)
    // to Gemini ko dobara call hi na karo — cached result turant do.
    // Isse quota bachta hai aur "2-3 requests ke baad fail" wala
    // masla kaafi had tak kam ho jata hai (repeat scans free hain).
    final imageHash = sha256.convert(bytes).toString();
    final cached = await _readFromCache(imageHash);
    if (cached != null) return cached;

    final apiKey = dotenv.env['Food_Analyzer'] ?? '';
    if (apiKey.isEmpty) throw Exception('Missing API Key');

    final base64Image = base64Encode(bytes);
    final mimeType = _detectMimeType(bytes);

    const prompt = '''You are a professional nutritionist API.
Return ONLY a raw JSON object. No markdown. No backticks. No explanation. No text before or after.

Analyze the food image and return exactly this format:
{"foodName":"string","cuisineType":"string","servingSize":"string","calories":0,"protein":0,"carbs":0,"fat":0,"fiber":0,"sugar":0,"sodium":0,"vitaminC":0,"iron":0,"healthScore":0,"allergens":["string"],"dietTags":["string"],"healthTips":["string","string","string"]}''';

    final uri = Uri.parse('$_baseUrl?key=$apiKey');
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'inline_data': {'mime_type': mimeType, 'data': base64Image},
            },
            {'text': prompt},
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.1,
        'maxOutputTokens': 2048,
        'responseMimeType': 'application/json',
      },
    });

    // ── STEP 2: Retry with backoff (asal bug fix) ────────────────
    final response = await _postWithRetry(uri, body);

    final data = jsonDecode(response.body);

    final candidates = data['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No response received. Try again.');
    }

    final finishReason = candidates[0]['finishReason'] as String? ?? '';
    if (finishReason == 'SAFETY' || finishReason == 'RECITATION') {
      throw Exception('Image blocked by API. Try another image.');
    }

    final parts = candidates[0]['content']?['parts'] as List?;
    if (parts == null || parts.isEmpty) {
      throw Exception('Empty response parts. Try again.');
    }

    final rawText = parts[0]['text'] as String? ?? '';
    if (rawText.isEmpty) throw Exception('Empty response. Try again.');

    final analysis = _parseFoodJson(rawText);

    // ── STEP 3: Save to cache for next time ──────────────────────
    await _saveToCache(imageHash, analysis);

    return analysis;
  }

  /// 3 attempts total (1 original + 2 retries). Sirf TRANSIENT
  /// errors par retry karta hai:
  /// - 429 (rate limit / quota)
  /// - 500/502/503/504 (server overload)
  /// - timeout / connection errors
  ///
  /// 400 jaisi client errors (bad request, malformed key) par
  /// FORAN fail hota hai — unhein retry karne ka koi fayda nahi,
  /// har baar wahi error milegi.
  static Future<http.Response> _postWithRetry(Uri uri, String body) async {
    const maxAttempts = 3;
    Exception? lastError;

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await http
            .post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: body,
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) return response;

        final isRetryable =
            response.statusCode == 429 ||
            response.statusCode == 500 ||
            response.statusCode == 502 ||
            response.statusCode == 503 ||
            response.statusCode == 504;

        if (!isRetryable || attempt == maxAttempts) {
          String errorDetail;
          try {
            final errData = jsonDecode(response.body);
            errorDetail = errData['error']?['message'] ?? response.body;
          } catch (_) {
            errorDetail = response.body;
          }

          if (isRetryable) {
            // Retryable tha lekin attempts khatam ho gaye — Gemini
            // abhi genuinely overloaded/rate-limited hai
            throw GeminiUnavailableException(
              'Gemini is busy right now (${response.statusCode}). $errorDetail',
            );
          }
          throw Exception('API Error ${response.statusCode}: $errorDetail');
        }

        // Retry-After header ho to usko follow karo, warna
        // exponential backoff: attempt 1 fail -> 2s wait, attempt 2
        // fail -> 4s wait
        final retryAfterHeader = response.headers['retry-after'];
        final waitSeconds =
            int.tryParse(retryAfterHeader ?? '') ?? (attempt * 2);
        await Future.delayed(Duration(seconds: waitSeconds));
      } on TimeoutException catch (e) {
        lastError = Exception('Request timed out: $e');
        if (attempt == maxAttempts) {
          throw GeminiUnavailableException(
            'Gemini is not responding right now. Please try again later.',
          );
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      } catch (e) {
        if (e is GeminiUnavailableException) rethrow;
        lastError = Exception('Connection error: $e');
        if (attempt == maxAttempts) {
          throw GeminiUnavailableException(
            'Could not reach Gemini. Check your internet connection.',
          );
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    // Yahan tak normally kabhi nahi pahunchna chahiye
    throw lastError ?? Exception('Unknown error contacting Gemini.');
  }

  static Future<FoodAnalysis?> _readFromCache(String imageHash) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_cachePrefix$imageHash');
      if (raw == null) return null;
      return FoodAnalysis.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Cache corrupt ya purani shape ho to bas ignore karo, Gemini
      // se fresh mangwa lo. Cache kabhi crash ki wajah nahi bannay
      // chahiye.
      return null;
    }
  }

  static Future<void> _saveToCache(
    String imageHash,
    FoodAnalysis analysis,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '$_cachePrefix$imageHash',
        jsonEncode(analysis.toJson()),
      );
    } catch (_) {
      // Cache save fail ho to bhi analysis result user ko mil chuka
      // hai — silently ignore karo, agli baar bas cache miss hoga.
    }
  }

  static String _detectMimeType(List<int> bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'image/jpeg';
    }
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46) {
      return 'image/webp';
    }
    return 'image/jpeg';
  }

  static FoodAnalysis _parseFoodJson(String rawText) {
    // Strategy 1: direct parse
    try {
      return FoodAnalysis.fromJson(
        jsonDecode(rawText.trim()) as Map<String, dynamic>,
      );
    } catch (_) {}

    final cleaned = rawText
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
    try {
      return FoodAnalysis.fromJson(jsonDecode(cleaned) as Map<String, dynamic>);
    } catch (_) {}

    final match = RegExp(r'\{[\s\S]*\}').firstMatch(cleaned);
    if (match != null) {
      try {
        return FoodAnalysis.fromJson(
          jsonDecode(match.group(0)!) as Map<String, dynamic>,
        );
      } catch (_) {}
    }

    throw Exception(
      'Response parse failed. Try again.\n'
      'Raw: ${rawText.length > 200 ? rawText.substring(0, 200) : rawText}',
    );
  }
}
