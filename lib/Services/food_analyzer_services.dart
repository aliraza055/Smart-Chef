import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/Models/food_anlysis_model.dart';

class AiServiceImage {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  static Future<FoodAnalysis> analyzeFoodImage(File imageFile) async {
    final apiKey = dotenv.env['Food_Analyzer'] ?? '';
    if (apiKey.isEmpty) throw Exception('Missing API Key');

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final mimeType = _detectMimeType(bytes);

    const prompt = '''You are a professional nutritionist API.
Return ONLY a raw JSON object. No markdown. No backticks. No explanation. No text before or after.

Analyze the food image and return exactly this format:
{"foodName":"string","cuisineType":"string","servingSize":"string","calories":0,"protein":0,"carbs":0,"fat":0,"fiber":0,"sugar":0,"sodium":0,"vitaminC":0,"iron":0,"healthScore":0,"allergens":["string"],"dietTags":["string"],"healthTips":["string","string","string"]}''';

    final uri = Uri.parse('$_baseUrl?key=$apiKey');

    late http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {
                      'inline_data': {
                        'mime_type': mimeType,
                        'data': base64Image,
                      },
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
            }),
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw Exception('Connection error: $e');
    }

    if (response.statusCode != 200) {
      String errorDetail = '';
      try {
        final errData = jsonDecode(response.body);
        errorDetail = errData['error']?['message'] ?? response.body;
      } catch (_) {
        errorDetail = response.body;
      }
      throw Exception('API Error ${response.statusCode}: $errorDetail');
    }

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

    return _parseFoodJson(rawText);
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
    // WebP check
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46) {
      return 'image/webp';
    }
    // Default fallback
    return 'image/jpeg';
  }

  static FoodAnalysis _parseFoodJson(String rawText) {
    // Strategy 1: direct parse
    try {
      return FoodAnalysis.fromJson(
        jsonDecode(rawText.trim()) as Map<String, dynamic>,
      );
    } catch (_) {}

    // Strategy 2: strip markdown fences
    final cleaned = rawText
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
    try {
      return FoodAnalysis.fromJson(jsonDecode(cleaned) as Map<String, dynamic>);
    } catch (_) {}

    // Strategy 3: regex extract {...}
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
