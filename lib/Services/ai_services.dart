import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/Models/ai_receipe_result_model.dart';

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
        '''You are a professional chef API. 
Return ONLY a raw JSON object. No markdown. No backticks. No explanation. No text before or after.

User has: $ingredientList
Basic pantry (salt, oil, water, spices) are allowed.

JSON format (exact keys required):
{"name":"string","description":"string","category":"Breakfast|Lunch|Dinner|Snack","difficulty":"easy|medium|hard","time":30,"ingredients":["item 1","item 2"],"steps":["Step 1","Step 2"]}''';

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
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.7,
                'maxOutputTokens': 2000,
                'responseMimeType': 'application/json',
              },
            }),
          )
          .timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw Exception(
        'The request timed out. Please check your internet connection and try again.',
      );
    } on SocketException {
      throw Exception(
        'Unable to connect to the internet. Please check your connection and try again.',
      );
    } catch (e) {
      throw Exception(
        'Unable to reach the AI service right now. Please try again.',
      );
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
      throw Exception('The AI did not return a response. Please try again.');
    }

    final rawText =
        candidates[0]['content']['parts'][0]['text'] as String? ?? '';

    if (rawText.isEmpty) {
      throw Exception('The AI returned an empty response. Please try again.');
    }

    return _parseRecipeJson(rawText);
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

    // Strategy 3: regex extract the first complete {...} block
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
