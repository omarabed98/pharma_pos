import 'package:get/get.dart';

import '../../../features/auth/binding/auth_binding.dart';
import '../../../features/auth/presentation/login/login_screen.dart';
import '../../../features/onboarding/binding/onboarding_binding.dart';
import '../../../features/onboarding/presentation/get_started_screen.dart';
import '../../../features/onboarding/presentation/onboarding_screen.dart';
import '../../../features/splash/binding/splash_binding.dart';
import '../../../features/splash/presentation/splash_screen.dart';
import 'app_routes.dart';

class AppNavigator {
  static final AppNavigator instance = AppNavigator._internal();
  AppNavigator._internal();

  List<GetPage> get routes {
    return [
      GetPage(
        name: AppRoutes.splash,
        page: () => const SplashScreen(),
        bindings: [SplashBinding()],
      ),

      // Onboarding
      GetPage(
        name: AppRoutes.onboarding,
        page: () => const OnboardingScreen(),
        bindings: [OnboardingBinding()],
      ),
      GetPage(
        name: AppRoutes.getStarted,
        page: () => const GetStartedScreen(),
        bindings: [OnboardingBinding()],
      ),

      // Auth
      GetPage(
        name: AppRoutes.login,
        page: () => LoginScreen(),
        bindings: [AuthBinding()],
      ),
    ];
  }
}
