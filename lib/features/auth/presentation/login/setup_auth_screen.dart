import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/cache/local_storage_service.dart';
import 'package:pos_pharma_app/core/domain/constants/image_manager.dart';
import 'package:pos_pharma_app/core/domain/utils/alerts.dart';
import 'package:pos_pharma_app/core/presentation/localization/localization_keys.dart';
import 'package:pos_pharma_app/core/presentation/theme/color_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/text_manager.dart';
import 'package:pos_pharma_app/core/presentation/widgets/app_button.dart';
import 'package:pos_pharma_app/core/presentation/widgets/fields/app_input_field.dart';

class SetupAuthScreen extends HookWidget with Alerts {
  const SetupAuthScreen({super.key});

  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager();
    final baseUrlController = useTextEditingController(
      text: LocalStorageService().baseUrl ?? '',
    );
    final isLoading = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          children: [
            // Logo
            Center(
              child: Image.asset(
                ImageManager().iconLogo,
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Center(
              child: Text(
                LocalizationKeys.setupServer.tr,
                style: AppTypography.headingS.bold.copyWith(
                  color: colors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Center(
              child: Text(
                LocalizationKeys.setupServerDescription.tr,
                textAlign: TextAlign.center,
                style: AppTypography.bodyS.medium.copyWith(
                  color: colors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Form
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Base URL Field
                  AppInputField.secondary(
                    controller: baseUrlController,
                    keyboardType: TextInputType.url,
                    required: true,
                    title: LocalizationKeys.baseUrl.tr,
                    hint: LocalizationKeys.baseUrlHint.tr,
                    enabled: !isLoading.value,
                    hasFillColor: true,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return LocalizationKeys.fieldRequired.tr;
                      }
                      if (!_isValidUrl(value.trim())) {
                        return LocalizationKeys.invalidUrl.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: AppButton.primary(
                      text: LocalizationKeys.saveConfiguration.tr,
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          isLoading.value = true;
                          final url = baseUrlController.text.trim();

                          // Ensure URL ends without trailing slash
                          final cleanUrl = url.endsWith('/')
                              ? url.substring(0, url.length - 1)
                              : url;

                          // Save to LocalStorage
                          LocalStorageService().baseUrl = cleanUrl;

                          // Show success message
                          showSuccessSnackbar(
                            text: LocalizationKeys
                                .configurationSavedSuccessfully
                                .tr,
                            iconData: Icons.check,
                          );

                          // Navigate back after a short delay
                          isLoading.value = false;
                          navigator?.pop();
                        }
                      },
                      isLoading: isLoading.value,
                      backgroundColor: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
