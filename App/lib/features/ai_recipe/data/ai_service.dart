import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/features/ai_recipe/models/ai_recipe_result.dart';

class GeminiUnavailableException implements Exception {
  final String message;
  GeminiUnavailableException(this.message);
  @override
  String toString() => message;
}

class AiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent';

  Future<AiRecipeResult> generateRecipe(List<String> ingredients) async {
    final ingredientList = ingredients.join(', ');
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key is missing. Check your .env file.');
    }

    final prompt =
        '''
You are a professional chef API.
Return ONLY valid JSON. No markdown, no text outside JSON.

Strictly follow this schema:
{
  "name":"string",
  "description":"string",
  "category":"Breakfast|Lunch|Dinner|Snack",
  "difficulty":"easy|medium|hard",
  "time":30,
  "ingredients":["item 1","item 2"],
  "steps":["Step 1","Step 2"]
}
User has: $ingredientList
Basic pantry (salt, oil, water, spices) are allowed.
''';

    final uri = Uri.parse('$_baseUrl?key=$apiKey');
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 2000,
        'responseMimeType': 'application/json',
      },
    });

    final response = await _postWithRetry(uri, body);

    final data = jsonDecode(response.body);

    final candidates = data['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('The AI did not return a response. Please try again.');
    }

    final rawText =
        candidates[0]['content']['parts'][0]['text'] as String? ?? '';

    if (rawText.isEmpty) {
      throw Exception('The AI returned an empty response. Please try again.');
    }

    return _parseRecipeJson(rawText);
  }

  /// 3 attempts total. Sirf transient errors (429/500/502/503/504,
  /// timeout, connection issues) par retry karta hai with exponential
  /// backoff. Non-retryable errors (400, invalid key waghera) par
  /// foran fail hota hai.
  Future<http.Response> _postWithRetry(Uri uri, String body) async {
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
            throw GeminiUnavailableException(
              'Gemini is busy right now (${response.statusCode}). $errorDetail',
            );
          }
          throw Exception('API Error ${response.statusCode}: $errorDetail');
        }

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
      } on SocketException {
        lastError = Exception('No internet connection.');
        if (attempt == maxAttempts) {
          throw Exception(
            'Unable to connect to the internet. Please check your connection and try again.',
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

    throw lastError ?? Exception('Unknown error contacting Gemini.');
  }

  AiRecipeResult _parseRecipeJson(String rawText) {
    try {
      final jsonMap = jsonDecode(rawText.trim()) as Map<String, dynamic>;
      return AiRecipeResult.fromJson(jsonMap);
    } catch (_) {}

    String cleaned = rawText
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
    try {
      final jsonMap = jsonDecode(cleaned) as Map<String, dynamic>;
      return AiRecipeResult.fromJson(jsonMap);
    } catch (_) {}

    final jsonRegex = RegExp(r'\{[\s\S]*\}');
    final match = jsonRegex.firstMatch(cleaned);
    if (match != null) {
      try {
        final jsonMap = jsonDecode(match.group(0)!) as Map<String, dynamic>;
        return AiRecipeResult.fromJson(jsonMap);
      } catch (_) {}
    }

    throw Exception('We could not parse the AI response. Please try again.');
  }
}

