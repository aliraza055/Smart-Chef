import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Constants/app_theme.dart';
import 'package:smart_chef/Controller/sign_up_controller.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Utils/app_responsive.dart';
import 'package:smart_chef/Widgets/auth_header.dart';
import 'package:smart_chef/Widgets/auth_social.dart';
import 'package:smart_chef/Widgets/textfield_widget.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.horizontalPadding(context, size: 24),
          ),
          child: Column(
            children: [
              SizedBox(height: AppResponsive.height(context, 60)),

              // ── Brand ──────────────────────────────
              const AuthBrandHeader(),

              const SizedBox(height: 32),

              // ── White Card ─────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppResponsive.width(context, 28)),
                decoration: BoxDecoration(
                  color: AppTheme.getSurface(context),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.getCardShadow(context),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: AppResponsive.text(context, 26),
                          fontWeight: FontWeight.w800,
                          color: AppTheme.getTextDark(context),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Join thousands of home chefs today.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.getTextMedium(context),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Social buttons ──────────────
                      const SocialLoginRow(),

                      const SizedBox(height: 24),

                      // ── Name ────────────────────────
                      AuthTextField(
                        controller: controller.nameController,
                        label: 'Full name',
                        hint: 'Gordon Ramsay',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter your name';
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // ── Email ───────────────────────
                      AuthTextField(
                        controller: controller.emailController,
                        label: 'Email address',
                        hint: 'chef@example.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter your email';
                          if (!v.contains('@')) return 'Enter valid email';
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // ── Password ────────────────────
                      AuthTextField(
                        controller: controller.passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: (v) {
                          if (v == null || v.length < 6) {
                            return 'Min 6 characters required';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppResponsive.height(context, 28)),

                      // ── Sign Up Button ──────────────
                      Obx(
                        () => GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : controller.signUp,
                          child: Container(
                            height: AppResponsive.height(context, 56),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.4),
                                  blurRadius: 16,
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
                                      'Create Account',
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

                      const SizedBox(height: 24),

                      // ── Sign In link ────────────────
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.getTextMedium(context),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                PageRouter.singIn,
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Footer ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FooterLink(label: 'Privacy Policy', onTap: () {}),
                  const SizedBox(width: 32),
                  _FooterLink(label: 'Terms of Service', onTap: () {}),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: AppTheme.getTextMedium(context),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

