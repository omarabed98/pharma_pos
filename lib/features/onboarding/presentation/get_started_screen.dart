import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/domain/constants/image_manager.dart';
import 'package:pos_pharma_app/core/presentation/localization/localization_keys.dart';
import 'package:pos_pharma_app/core/presentation/theme/color_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/text_manager.dart';
import 'package:pos_pharma_app/core/presentation/widgets/app_button.dart';

import 'get_started_controller.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<GetStartedController>(
          init: GetStartedController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight),
                  // Title
                  Text(
                    LocalizationKeys.getStartedText.tr,
                    style: AppTypography.headingM.copyWith(
                      color: ColorManager().lightOnSurface,
                      fontFamily: AppFonts.inter,
                      fontSize: 34,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    LocalizationKeys.getStartedDescription.tr,
                    style: AppTypography.bodyM.copyWith(
                      color: ColorManager().lightOnSurface.withValues(
                        alpha: 0.7,
                      ),
                      fontFamily: AppFonts.cairoSlant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // Image
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        ImageManager().getStarted,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Login button
                  AppButton.primary(
                    text: LocalizationKeys.loginToExistingAccount.tr,
                    onPressed: controller.goToLogin,
                    height: 55,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
