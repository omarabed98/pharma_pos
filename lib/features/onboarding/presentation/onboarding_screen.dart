import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/domain/constants/image_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/color_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/text_manager.dart';
import 'package:pos_pharma_app/core/presentation/widgets/app_button.dart';

import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<OnboardingController>(
          init: OnboardingController(),
          builder: (controller) {
            return Column(
              children: [
                // Progress indicators
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: controller.currentPage >= index
                                ? ColorManager().primary
                                : ColorManager().primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // PageView
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    children: [
                      _OnboardingPage(
                        image: ImageManager().onboarding1,
                        title: 'Find Medicines',
                        description:
                            'Easily find your prescribed medicines from a variety of registered pharmacies, no matter where you are.',
                      ),
                      _OnboardingPage(
                        image: ImageManager().onboarding2,
                        title: 'Select Pharmacy',
                        description:
                            'Pick the pharmacy that suits you best. We\'ve got trusted options and reliable options in our network.',
                      ),
                      _OnboardingPage(
                        image: ImageManager().onboarding3,
                        title: 'Pharmacy Management',
                        description:
                            'Easily manage orders and maintain an organized, top-notch service for customers. Update drug details manually or through file uploads for an up-to-date catalog.',
                      ),
                    ],
                  ),
                ),
                // Continue button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AppButton.primary(
                    text: 'Continue',
                    onPressed: controller.nextPage,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Title
          Text(
            title,
            style: AppTypography.headingM.copyWith(
              color: ColorManager().lightOnSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            description,
            style: AppTypography.bodyM.copyWith(
              color: ColorManager().lightOnSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Image
          Image.asset(
            image,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ],
      ),
    );
  }
}

