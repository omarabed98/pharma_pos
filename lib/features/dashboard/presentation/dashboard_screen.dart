import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/cache/local_storage_service.dart';
import 'package:pos_pharma_app/core/presentation/localization/localization_keys.dart';
import 'package:pos_pharma_app/core/presentation/theme/color_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/text_manager.dart';
import 'package:pos_pharma_app/features/auth/presentation/auth_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager();
    final user = LocalStorageService().user;
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          LocalizationKeys.dashboard.tr,
          style: AppTypography.headingM.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              if (user != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LocalizationKeys.welcomeBack.tr}, ${user.username}',
                          style: AppTypography.headingS.bold,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email,
                          style: AppTypography.bodyM.regular.copyWith(
                            color: colors.textDark.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              // Dashboard content placeholder
              Expanded(
                child: Center(
                  child: Text(
                    LocalizationKeys.dashboard.tr,
                    style: AppTypography.headingM.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
