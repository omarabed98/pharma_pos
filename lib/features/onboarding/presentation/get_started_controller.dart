import 'package:get/get.dart';
import 'package:pos_pharma_app/core/cache/local_storage_service.dart';
import 'package:pos_pharma_app/core/domain/routing/app_routes.dart';

class GetStartedController extends GetxController {
  void goToLogin() {
    // Mark onboarding as seen
    LocalStorageService().hasSeenOnboarding = true;
    // Navigate to login
    Get.offAllNamed(AppRoutes.login);
  }
}

