import 'package:get/get.dart';

class IngredientsChecklistController extends GetxController {
  IngredientsChecklistController(int length) {
    checked.assignAll(List.generate(length, (_) => false));
  }

  final RxList<bool> checked = <bool>[].obs;

  void toggle(int index) {
    if (index < 0 || index >= checked.length) return;
    checked[index] = !checked[index];
  }
}

