import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/domain/routing/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  void nextPage() {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to get started screen
      Get.offNamed(AppRoutes.getStarted);
    }
  }

  void skipToGetStarted() {
    Get.offNamed(AppRoutes.getStarted);
  }
}

