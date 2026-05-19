import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiRecipeResult {
  final String name;
  final String description;
  final String category;
  final String difficulty;
  final double time;
  final List<String> ingredients;
  final List<String> steps;

  AiRecipeResult({
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.time,
    required this.ingredients,
    required this.steps,
  });

  factory AiRecipeResult.fromJson(Map<String, dynamic> json) {
    return AiRecipeResult(
      name: json['name'] ?? 'AI Recipe',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Dinner',
      difficulty: json['difficulty'] ?? 'medium',
      time: (json['time'] ?? 30).toDouble(),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
    );
  }
}

class AiService {
  final _apiKey = dotenv.env['GEMINI_API_KEY'];
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  Future<AiRecipeResult> generateRecipe(List<String> ingredients) async {
    final ingredientList = ingredients.join(', ');

    // Stricter prompt — tells Gemini explicitly what NOT to do
    final prompt =
        '''You are a professional chef API. 
Return ONLY a raw JSON object. No markdown. No backticks. No explanation. No text before or after.

User has: $ingredientList
Basic pantry (salt, oil, water, spices) are allowed.

JSON format (exact keys required):
{"name":"string","description":"string","category":"Breakfast|Lunch|Dinner|Snack","difficulty":"easy|medium|hard","time":30,"ingredients":["item 1","item 2"],"steps":["Step 1","Step 2"]}''';

    final uri = Uri.parse('$_baseUrl?key=$_apiKey');

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
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.7,
                'maxOutputTokens': 2048,
                // This forces Gemini to output JSON only
                'responseMimeType': 'application/json',
              },
            }),
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw Exception('Internet connection error: $e');
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

    if (rawText.isEmpty) {
      throw Exception('Response khali hai. Dobara try karo.');
    }

    return _parseRecipeJson(rawText);
  }

  AiRecipeResult _parseRecipeJson(String rawText) {
    // Strategy 1: direct parse (works when responseMimeType is set)
    try {
      final jsonMap = jsonDecode(rawText.trim()) as Map<String, dynamic>;
      return AiRecipeResult.fromJson(jsonMap);
    } catch (_) {}

    // Strategy 2: strip markdown fences then parse
    String cleaned = rawText
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
    try {
      final jsonMap = jsonDecode(cleaned) as Map<String, dynamic>;
      return AiRecipeResult.fromJson(jsonMap);
    } catch (_) {}

    // Strategy 3: regex extract the first complete {...} block
    final jsonRegex = RegExp(r'\{[\s\S]*\}');
    final match = jsonRegex.firstMatch(cleaned);
    if (match != null) {
      try {
        final jsonMap = jsonDecode(match.group(0)!) as Map<String, dynamic>;
        return AiRecipeResult.fromJson(jsonMap);
      } catch (_) {}
    }

    throw Exception(
      'AI ka response parse nahi ho saka. Dobara try karo.\n'
      'Raw: ${rawText.length > 200 ? rawText.substring(0, 200) : rawText}',
    );
  }
}
