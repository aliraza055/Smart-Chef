import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/core/constants/app_theme.dart';
import 'package:smart_chef/features/add_recipe/controllers/add_recipe_controller.dart';
import 'package:smart_chef/core/utils/app_responsive.dart';
import 'package:smart_chef/features/add_recipe/presentation/widgets/recipe_image_picker.dart';
import 'package:smart_chef/features/add_recipe/presentation/widgets/ingredients_editor.dart';
import 'package:smart_chef/features/add_recipe/presentation/widgets/steps_editor.dart';
import 'package:smart_chef/features/add_recipe/presentation/widgets/category_selector.dart';

//
class AddReceipe extends StatelessWidget {
  const AddReceipe({super.key});

  @override
  Widget build(BuildContext context) {
    final AddRecipeController controller = Get.put(AddRecipeController());
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 56),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: AppResponsive.width(context, 40),
                      height: AppResponsive.height(context, 40),
                      decoration: BoxDecoration(
                        color: AppTheme.getSurface(context),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppTheme.getCardShadow(context), blurRadius: 8),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.width(context, 14)),
                  Text(
                    'Smart Chef',
                    style: TextStyle(
                      fontSize: AppResponsive.text(context, 20),
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Title
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 28),
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 4),
              ),
              child: Text(
                'Create Recipe',
                style: TextStyle(
                  fontSize: AppResponsive.text(context, 28),
                  fontWeight: FontWeight.w800,
                  color: AppTheme.getTextDark(context),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Obx(
                () => RecipeImagePicker(
                  image: controller.image.value,
                  onTap: controller.pickImage,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RECIPE TITLE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.getSurface(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: controller.titleController,
                      decoration: const InputDecoration(
                        hintText: "e.g. Grandma's Secret Pasta",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Category
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Obx(
                () => CategorySelector(
                  categories: AddRecipeController.categories,
                  selected: controller.selectedCategory.value,
                  onSelected: controller.selectCategory,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: GetBuilder<AddRecipeController>(
                builder: (_) => IngredientsEditor(
                  controllers: controller.ingredientControllers,
                  onAdd: controller.addIngredient,
                  onDelete: controller.deleteIngredient,
                ),
              ),
            ),
          ),

          // ── Steps
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: GetBuilder<AddRecipeController>(
                builder: (_) => PreparationStepsEditor(
                  controllers: controller.stepControllers,
                  onAdd: controller.addStep,
                  onDelete: controller.deleteStep,
                ),
              ),
            ),
          ),

          // ── Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 32),
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 40),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.saveDraft,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 1.8,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'SAVE DRAFT',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : controller.publish,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  )
                                : const Text(
                                    'PUBLISH RECIPE',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

