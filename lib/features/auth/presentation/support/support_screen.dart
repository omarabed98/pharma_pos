import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/presentation/localization/localization_keys.dart';
import 'package:pos_pharma_app/core/presentation/theme/color_manager.dart';
import 'package:pos_pharma_app/core/presentation/theme/text_manager.dart';
import 'package:pos_pharma_app/core/presentation/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _callSupport(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        LocalizationKeys.unknownError.tr,
        LocalizationKeys.somethingWentWrong.tr,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager();
    final phoneNumber = LocalizationKeys.supportPhoneNumber.tr;

    return Scaffold(
      appBar: AppBar(title: Text(LocalizationKeys.supportTitle.tr)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Support Icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.support_agent,
                  size: 50,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Support Description
            Text(
              LocalizationKeys.supportDescription.tr,
              textAlign: TextAlign.center,
              style: AppTypography.bodyM.regular.copyWith(
                color: colors.textDark,
                fontFamily: AppFonts.cairoSlant,
              ),
            ),
            const SizedBox(height: 40),

            // Contact Support Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, color: colors.primary, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          LocalizationKeys.contactSupport.tr,
                          style: AppTypography.headingS.bold.copyWith(
                            color: colors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      LocalizationKeys.ifYouFaceAnyProblem.tr,
                      style: AppTypography.bodyM.regular.copyWith(
                        color: colors.textDark.withValues(alpha: 0.7),
                        fontFamily: AppFonts.cairoSlant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Phone Number
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            color: colors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              phoneNumber,
                              style: AppTypography.headingS.bold.copyWith(
                                color: colors.primary,
                                fontFamily: AppFonts.cairo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Call Button
                    AppButton.primary(
                      text: LocalizationKeys.callSupport.tr,
                      onPressed: () => _callSupport(phoneNumber),
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Base URL Instructions Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          LocalizationKeys.baseUrlInstructions.tr,
                          style: AppTypography.headingS.bold.copyWith(
                            color: colors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocalizationKeys.baseUrlInstructionsDescription.tr,
                      style: AppTypography.bodyM.regular.copyWith(
                        color: colors.textDark.withValues(alpha: 0.7),
                        fontFamily: AppFonts.cairoSlant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Example
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.border.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.code, color: colors.primary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              LocalizationKeys.baseUrlExample.tr,
                              style: AppTypography.bodyM.medium.copyWith(
                                color: colors.textDark,
                                fontFamily: AppFonts.cairo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Steps
                    Text(
                      LocalizationKeys.howToSetupBaseUrl.tr,
                      style: AppTypography.subheadingM.bold.copyWith(
                        color: colors.textDark,
                        fontFamily: AppFonts.cairoSlant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStep(
                      colors,
                      1,
                      LocalizationKeys.step1SetupBaseUrl.tr,
                    ),
                    const SizedBox(height: 8),
                    _buildStep(
                      colors,
                      2,
                      LocalizationKeys.step2SetupBaseUrl.tr,
                    ),
                    const SizedBox(height: 8),
                    _buildStep(
                      colors,
                      3,
                      LocalizationKeys.step3SetupBaseUrl.tr,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(ColorManager colors, int stepNumber, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$stepNumber',
              style: AppTypography.bodyS.bold.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyM.regular.copyWith(
              color: colors.textDark.withValues(alpha: 0.8),
              fontFamily: AppFonts.cairoSlant,
            ),
          ),
        ),
      ],
    );
  }
}
