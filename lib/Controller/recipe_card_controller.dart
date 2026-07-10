import 'package:get/get.dart';

class RecipeCardController extends GetxController {
  final RxBool isFavorite = false.obs;

  void syncWithValue(bool value) {
    isFavorite.value = value;
  }

  void toggle() {
    isFavorite.value = !isFavorite.value;
  }
}
