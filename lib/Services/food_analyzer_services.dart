import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/Models/food_anlysis_model.dart';

class AiServiceImage {
  final _apiKey = dotenv.env['Food_Analyzer'];
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  static Future<FoodAnalysis> analyzeFoodImage(File imageFile) async {
    final apiKey = dotenv.env['Food_Analyzer'] ?? '';
    if (apiKey.isEmpty) throw Exception('Missing API Key');

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    final ext = imageFile.path.split('.').last.toLowerCase();
    final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

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
                'maxOutputTokens': 1024,
                'responseMimeType':
                    'application/json', // ✅ camelCase — yahi fix hai
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

    final rawText =
        candidates[0]['content']['parts'][0]['text'] as String? ?? '';

    if (rawText.isEmpty) throw Exception('Empty response. Try again.');

    return _parseFoodJson(rawText);
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
