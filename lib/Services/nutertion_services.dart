import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NutritionResult {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final String servingNote;
  final List<Map<String, dynamic>> perIngredient;

  NutritionResult({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.servingNote,
    required this.perIngredient,
  });

  factory NutritionResult.fromJson(Map<String, dynamic> json) {
    final total = json['total'] ?? {};
    final items = json['per_ingredient'] as List<dynamic>? ?? [];

    return NutritionResult(
      calories: (total['calories'] ?? 0).toInt(),
      protein: (total['protein_g'] ?? 0).toDouble(),
      carbs: (total['carbs_g'] ?? 0).toDouble(),
      fat: (total['fat_g'] ?? 0).toDouble(),
      fiber: (total['fiber_g'] ?? 0).toDouble(),
      servingNote: json['serving_note'] ?? 'Per full recipe',
      perIngredient: items
          .map(
            (e) => {
              'name': e['name'] ?? '',
              'calories': (e['calories'] ?? 0).toInt(),
            },
          )
          .toList(),
    );
  }
}

class NutritionService {
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  Future<NutritionResult> estimate(List<String> ingredients) async {
    final ingredientList = ingredients.join('\n- ');

    final prompt =
        '''You are a certified nutritionist API.
Return ONLY a raw JSON object. No markdown. No backticks. No explanation. No text before or after.

Estimate nutrition for a recipe with these ingredients:
- $ingredientList

JSON format (exact keys required):
{"total":{"calories":450,"protein_g":32.5,"carbs_g":28.0,"fat_g":14.2,"fiber_g":5.1},"serving_note":"Estimated for 2 servings","per_ingredient":[{"name":"chicken breast","calories":165},{"name":"tomatoes","calories":18}]}''';

    late http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('$_baseUrl?key=$apiKey'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.3,
                'maxOutputTokens': 1500,
                // responseMimeType intentionally removed
              },
            }),
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw Exception('Internet error: $e');
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
      throw Exception('Koi response nahi mila. Dobara try karo.');
    }

    final rawText =
        candidates[0]['content']['parts'][0]['text'] as String? ?? '';

    print('🟡 RAW NUTRITION: $rawText'); // debug — baad mein hata dena

    if (rawText.isEmpty) {
      throw Exception('Response khali hai. Dobara try karo.');
    }

    return _parseNutritionJson(rawText);
  }

  NutritionResult _parseNutritionJson(String rawText) {
    // Strategy 1: direct parse
    try {
      return NutritionResult.fromJson(
        jsonDecode(rawText.trim()) as Map<String, dynamic>,
      );
    } catch (_) {}

    // Strategy 2: markdown fence hata ke parse
    String cleaned = rawText
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
    try {
      return NutritionResult.fromJson(
        jsonDecode(cleaned) as Map<String, dynamic>,
      );
    } catch (_) {}

    // Strategy 3: regex se pehla { } block nikalo
    final match = RegExp(r'\{[\s\S]*\}').firstMatch(cleaned);
    if (match != null) {
      try {
        return NutritionResult.fromJson(
          jsonDecode(match.group(0)!) as Map<String, dynamic>,
        );
      } catch (_) {}
    }

    throw Exception(
      'Parse error. Raw: ${rawText.length > 150 ? rawText.substring(0, 150) : rawText}',
    );
  }
}
