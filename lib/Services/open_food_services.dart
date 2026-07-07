import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_chef/Models/food_anlysis_model.dart';

/// Open Food Facts ek user-contributed database hai jo mostly
/// PACKAGED products (barcode wale items — chips, drinks, cereal,
/// etc) ke liye acha data deta hai. Homemade dishes (jaise "chicken
/// biryani" ya "daal chawal") ke liye is mein data milne ka chance
/// kam hai, kyunki ye AI image-recognition system nahi, sirf ek
/// text/barcode search hai.
///
/// Isi wajah se ye service sirf FALLBACK ke tor pe use ho rahi hai:
/// jab Gemini teen retries ke baad bhi fail ho jaye, controller user
/// ko ek chhota "food ka naam type karo" box dikhata hai, aur wahan
/// se ye service best-effort nutrition data dhoondhti hai — takay
/// app ka flow poori tarah na ruke.
class OpenFoodFactsService {
  static const String _searchUrl =
      'https://world.openfoodfacts.org/cgi/search.pl';

  static Future<FoodAnalysis> searchByName(String query) async {
    final uri = Uri.parse(_searchUrl).replace(
      queryParameters: {
        'search_terms': query,
        'search_simple': '1',
        'action': 'process',
        'json': '1',
        'page_size': '5',
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Open Food Facts error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final products = data['products'] as List?;

    if (products == null || products.isEmpty) {
      throw Exception(
        'No match found for "$query". Try a more specific or '
        'branded name — Open Food Facts works best for packaged '
        'products.',
      );
    }

    // Pehla wo product uthao jismein kam-az-kam calories ka data ho
    // — bohot se entries incomplete hote hain.
    final product = products.firstWhere(
      (p) =>
          p['nutriments'] != null &&
          p['nutriments']['energy-kcal_100g'] != null,
      orElse: () => products.first,
    );

    final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

    double numVal(String key) => (nutriments[key] as num?)?.toDouble() ?? 0;

    final allergensTags =
        (product['allergens_tags'] as List?)
            ?.map((e) => e.toString().replaceFirst('en:', ''))
            .toList() ??
        <String>[];

    final productName = product['product_name']?.toString();

    return FoodAnalysis(
      foodName: (productName != null && productName.isNotEmpty)
          ? productName
          : query,
      cuisineType:
          (product['categories'] as String?)?.split(',').first.trim() ??
          'Unknown',
      servingSize: product['serving_size']?.toString() ?? 'Per 100g',
      calories: numVal('energy-kcal_100g').round(),
      protein: numVal('proteins_100g'),
      carbs: numVal('carbohydrates_100g'),
      fat: numVal('fat_100g'),
      fiber: numVal('fiber_100g'),
      sugar: numVal('sugars_100g'),
      sodium: numVal('sodium_100g') * 1000, // g -> mg
      vitaminC: 0, // OFF mein ye field zyada tar products mein missing hoti hai
      iron: 0,
      healthScore:
          50, // OFF health-score nahi deta jaisa Gemini deta hai — neutral default
      allergens: allergensTags,
      dietTags: const [],
      healthTips: const [
        'This data is from Open Food Facts (approximate, per 100g).',
        'For homemade dishes, exact values may differ — use as a general guide only.',
      ],
      isEstimated: true,
    );
  }
}
