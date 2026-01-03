import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/presentation/widgets/app_button.dart';
import 'package:pos_pharma_app/core/presentation/widgets/fields/app_input_field.dart';

import '../../../../core/presentation/localization/localization_keys.dart';
import '../auth_controller.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Scaffold(
      body: GetBuilder(
        init: AuthController(
          repository: Get.find(),
          tokenManager: Get.find(),
          sessionManager: Get.find(),
        ),
        id: LoginScreen,
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            children: [
              const SizedBox(height: kToolbarHeight),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      LocalizationKeys.signIn.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Form(
                child: Builder(
                  builder: (context) {
                    return Column(
                      children: [
                        AppInputField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          required: true,
                          hint: LocalizationKeys.email.tr,
                          enabled: controller.authState != AuthState.loading,
                        ),
                        const SizedBox(height: 24),
                        AppInputField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          required: true,
                          hint: LocalizationKeys.password.tr,
                          enabled: controller.authState != AuthState.loading,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton.primary(
                            text: LocalizationKeys.signIn.tr,
                            onPressed: () {
                              if (Form.of(context).validate()) {
                                controller.emailLogin(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                            },
                            isLoading:
                                controller.authState == AuthState.loading,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
