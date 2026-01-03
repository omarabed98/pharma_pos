import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/domain/constants/image_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/color_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/text_manager.dart';
import 'package:pos_pharma_app/core/presentation/widgets/app_button.dart';
import 'package:pos_pharma_app/core/presentation/widgets/app_clickable.dart';
import 'package:pos_pharma_app/core/presentation/widgets/fields/app_input_field.dart';

import '../../../../core/domain/routing/app_routes.dart';
import '../../../../core/presentation/localization/localization_keys.dart';
import '../auth_controller.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: AuthController(
          repository: Get.find(),
          tokenManager: Get.find(),
          sessionManager: Get.find(),
        ),
        id: LoginScreen,
        builder: (controller) {
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    ImageManager().iconLogo,
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 16),
                // Welcome Text
                Center(
                  child: Text(
                    LocalizationKeys.welcomeToPharmaApp.tr,
                    style: AppTypography.headingS.bold.copyWith(
                      color: colors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Form
                Form(
                  child: Builder(
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username Field
                          AppInputField.secondary(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            required: true,
                            title: LocalizationKeys.username.tr,
                            hint: LocalizationKeys.username.tr,
                            enabled: controller.authState != AuthState.loading,
                            hasFillColor: true,
                          ),
                          const SizedBox(height: 24),
                          // Password Field
                          AppInputField.secondary(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            required: true,
                            title: LocalizationKeys.password.tr,
                            hint: LocalizationKeys.password.tr,
                            enabled: controller.authState != AuthState.loading,
                            hasFillColor: true,
                          ),
                          const SizedBox(height: 8),
                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: AppClickable(
                              onClick: () {
                                Get.toNamed(AppRoutes.support);
                              },
                              child: Text(
                                LocalizationKeys.forgotPasswordQ.tr,
                                style: AppTypography.bodyS.medium.copyWith(
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: AppButton.primary(
                              text: LocalizationKeys.signIn.tr,
                              onPressed: () {
                                if (Form.of(context).validate()) {
                                  controller.manualLogin(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                                }
                              },
                              isLoading:
                                  controller.authState == AuthState.loading,
                              backgroundColor: colors.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: colors.border,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  LocalizationKeys.orSetupWith.tr,
                                  style: AppTypography.bodyS.medium.copyWith(
                                    color: colors.textDark,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: colors.border,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Setup Server Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.setupAuth);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                side: BorderSide(
                                  color: colors.disabled,
                                  width: 1.6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.settings_outlined,
                                    size: 20,
                                    color: colors.disabled,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    LocalizationKeys.setupServer.tr,
                                    style: AppTypography.subheadingM.bold
                                        .copyWith(color: colors.disabled),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
