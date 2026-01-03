import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pos_pharma_app/core/cache/local_storage_service.dart';
import 'package:pos_pharma_app/core/domain/routing/app_routes.dart';
import 'package:pos_pharma_app/core/presentation/widgets/app_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/domain/utils/alerts.dart';
import '../../../core/presentation/localization/localization_keys.dart';
import '../data/repository/splash_repo.dart';
import '../domain/models/app_version.dart';

class SplashController extends GetxController with Alerts {
  final SplashRepositoryAbstraction _repository;

  SplashController({required SplashRepositoryAbstraction repository})
    : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    // FirebaseAnalytics.instance.logAppOpen(
    //   parameters: {
    //     'device_type': Platform.operatingSystem,
    //     'device_version': Platform.operatingSystemVersion,
    //   },
    // );
    checkConnectivity();
  }

  void checkConnectivity() async {
    await Future.delayed(const Duration(seconds: 2));
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity.contains(ConnectivityResult.none)) {
      Get.dialog(
        barrierDismissible: false,
        AppDialog(
          dismissible: false,
          title: LocalizationKeys.noConnection.tr,
          description: LocalizationKeys.noConnectionDesc.tr,
          actionText: LocalizationKeys.retry.tr,
          onAction: () {
            Get.back();
            checkConnectivity();
          },
        ),
      );
      return;
    }

    // Check if first time opening app and no token
    await checkFirstTimeAndNavigate();

    // checkAvailableUpdate();
  }

  Future<void> checkFirstTimeAndNavigate() async {
    final hasSeenOnboarding = LocalStorageService().hasSeenOnboarding;
    final accessToken = await _repository.fetchAccessToken();

    // If first time and no token, go to onboarding
    if (!hasSeenOnboarding && accessToken.isEmpty) {
      Get.offNamed(AppRoutes.onboarding);
      return;
    }

    // Otherwise, proceed with token verification
    verifyToken();
  }

  void checkAvailableUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final response = await _repository.checkAvailableUpdate(packageInfo);

    response.fold(
      (failure) {
        Get.dialog(
          barrierDismissible: false,
          AppDialog(
            dismissible: false,
            title: LocalizationKeys.somethingWentWrong.tr,
            description: failure.message,
            actionText: LocalizationKeys.retry.tr,
            onAction: () {
              Get.back();
              checkAvailableUpdate();
            },
          ),
        );
      },
      (appVersion) {
        switch (appVersion.status) {
          case UpdateStatus.hard:
            Get.dialog(
              barrierDismissible: false,
              AppDialog(
                dismissible: false,
                title: LocalizationKeys.updateAppTitle.tr,
                description: LocalizationKeys.updateAppDescription.tr,
                actionText: LocalizationKeys.updateApp.tr,
                onAction: () => redirectToStore(appVersion.url!),
              ),
            );
          case UpdateStatus.soft:
            Get.dialog(
              barrierDismissible: false,
              AppDialog(
                dismissible: false,
                title: LocalizationKeys.updateAppTitle.tr,
                description: LocalizationKeys.updateAppDescription.tr,
                actionText: LocalizationKeys.updateApp.tr,
                onAction: () => redirectToStore(appVersion.url!),
                cancelText: LocalizationKeys.later.tr,
                onCancel: () => verifyToken(),
              ),
            );
          case UpdateStatus.none:
            verifyToken();
        }
      },
    );
  }

  Future<void> redirectToStore(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showFailSnackbar(text: LocalizationKeys.somethingWentWrong.tr);
    }
  }

  Future<void> verifyToken() async {
    final accessToken = await _repository.fetchAccessToken();

    if (accessToken.isEmpty) {
      Get.offNamed(AppRoutes.login);
      return;
    }

    final response = await _repository.verifyToken(accessToken);
    response.fold(
      (failure) {
        Get.offNamed(AppRoutes.login);
        showFailSnackbar(text: failure.message);
      },
      (_) {
        // Get.offNamed(AppRoutes.dashboard);
      },
    );
  }
}
