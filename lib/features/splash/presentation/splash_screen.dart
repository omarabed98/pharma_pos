import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/domain/constants/image_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/text_manager.dart';

import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController(repository: Get.find()));
    return Scaffold(body: SplashBackgroundView());
  }
}

class SplashBackgroundView extends StatelessWidget {
  const SplashBackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImageManager().iconLogoZ, width: 125, height: 125),
          const SizedBox(height: 20),
          Text(
            "Pos Pharma App",
            style: AppTypography.headingM.copyWith(fontSize: 28),
          ),
        ],
      ),
    );
  }
}
