import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Controller/update_user_controller.dart';
import 'package:smart_chef/Utils/app_responsive.dart';
import 'package:smart_chef/Widgets/safe_image.dart';
import 'package:smart_chef/Widgets/textfield_widget.dart';

class UpdateUser extends StatelessWidget {
  const UpdateUser({super.key});

  @override
  Widget build(BuildContext context) {
    final UpdateUserController controller = Get.put(UpdateUserController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ────────────────────────────────
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
                        color: AppTheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppTheme.cardShadow, blurRadius: 8),
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
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Avatar ────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 36),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Center(
                child: Stack(
                  children: [
                    Obx(
                      () => Container(
                        width: AppResponsive.width(context, 110),
                        height: AppResponsive.height(context, 110),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primary, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.2),
                              blurRadius: 19,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: controller.image.value != null
                              ? Image.file(
                                  controller.image.value!,
                                  fit: BoxFit.cover,
                                )
                              : SafeNetworkImage(
                                  url: controller.currentPhotoUrl,
                                  fit: BoxFit.cover,
                                  placeholder: Container(
                                    color: const Color(0xFFEEEEEE),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      size: 54,
                                      color: AppTheme.textLight,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    // Edit badge
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Name display below avatar ──────────────
          // NOTE: pehle ye Text sirf _isLoading/_image jaisi setState
          // calls ke waqt hi refresh hoti thi (typing pe khud rebuild
          // nahi hoti thi). ValueListenableBuilder se ab ye live
          // update hogi jaise-jaise user type karega — ek chhota
          // bonus fix, GetX se related nahi, seedha Flutter feature.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.nameController,
                    builder: (context, value, _) => Text(
                      value.text.isEmpty ? 'Your Name' : value.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.emailController.text,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Form Card ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 32),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.cardShadow,
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Full Name
                    AuthTextField(
                      controller: controller.nameController,
                      label: 'Full Name',
                      hint: 'Enter your name',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter your name' : null,
                    ),

                    const SizedBox(height: 18),

                    // Email — read only
                    AuthTextField(
                      controller: controller.emailController,
                      label: 'Email address',
                      hint: 'chef@example.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 6),
                    const Text(
                      '* Email cannot be changed here.',
                      style: TextStyle(fontSize: 11, color: AppTheme.textLight),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Save Button ───────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 28),
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 40),
              ),
              child: Obx(
                () => GestureDetector(
                  onTap: controller.isLoading.value
                      ? null
                      : controller.saveChanges,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
