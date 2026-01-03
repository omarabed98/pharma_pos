import 'package:get/get.dart';

import '../../../core/domain/utils/alerts.dart';
import '../../../core/presentation/localization/localization_keys.dart';
import '../../../core/services/session_manager_service.dart';
import '../../../core/services/token_manager_service.dart';
import '../data/repository/auth_repo.dart';
import '../domain/models/auth_credentials.dart';
import 'login/login_screen.dart';

enum AuthState { initial, loading, success, failure }

class AuthController extends GetxController with Alerts {
  final AuthRepositoryAbstraction _repository;
  final TokenManagerService _tokenManager;
  final SessionManagerService _sessionManager;

  AuthController({
    required AuthRepositoryAbstraction repository,
    required TokenManagerService tokenManager,
    required SessionManagerService sessionManager,
  }) : _repository = repository,
       _tokenManager = tokenManager,
       _sessionManager = sessionManager;

  AuthState authState = AuthState.initial;

  Future<void> emailLogin({
    required String email,
    required String password,
  }) async {
    authState = AuthState.loading;
    update([LoginScreen]);

    final response = await _repository.manualLogin(email, password);
    response.fold(
      (failure) {
        authState = AuthState.failure;
        showFailSnackbar(text: failure.message);
        update([LoginScreen]);
      },
      (credentials) {
        continueToApp(credentials: credentials);
      },
    );
  }

  /// When browsing as a guest, call this method with null params.
  /// With null params (Guest) the access token will not be saved.
  /// If a was token saved before, it will be removed.
  /// And logging in as guest won't count for setting first login.
  Future<void> continueToApp({AuthCredentials? credentials}) async {
    if (credentials != null) {
      await _repository.setAccessToken(
        accessToken: credentials.access,
        refreshToken: credentials.refresh,
      );

      // Reset refresh attempts counter after successful login
      _tokenManager.resetRefreshAttempts();
    }

    authState = AuthState.success;
    // if (credentials != null) {
    //   await Get.find<ProfileController>().fetchUser();
    // }
    update([LoginScreen]);
    // FirebaseAnalytics.instance.setUserId(
    //   id: '${credentials?.user.userId ?? 'guest'}',
    // );
    if (credentials != null) {
      // ArabGTAnalyticsService.logEvent(
      //   name: 'login',
      //   parameters: {
      //     'method': credentials.loginMethod.name,
      //     'name': credentials.user.username,
      //     'email': credentials.user.email,
      //     'device_type': Platform.operatingSystem,
      //     'device_version': Platform.operatingSystemVersion,
      //   },
      // );

      // Get.offNamed(
      //   AppRoutes.questionnaire,
      //   arguments: UserProfile.empty().copyWith(
      //     firstName: credentials.user.firstName,
      //     lastName: credentials.user.lastName,
      //     email: credentials.user.email,
      //     nickname: credentials.user.username,
      //   ),
      // );
      return;
    }

    // ArabGTAnalyticsService.logEvent(
    //   name: 'login',
    //   parameters: {
    //     'method': 'guest',
    //     'name': credentials?.user.username ?? 'guest',
    //     'email': credentials?.user.email ?? 'guest',
    //     'device_type': Platform.operatingSystem,
    //     'device_version': Platform.operatingSystemVersion,
    //   },
    // );
    // Get.offNamed(ArabgtRoutes.dashboard);
  }

  /// Handles user logout using the session manager
  Future<void> logout() async {
    try {
      authState = AuthState.loading;
      update();

      await _sessionManager.handleUserLogout();

      authState = AuthState.initial;
      update();
    } catch (e) {
      authState = AuthState.failure;
      showFailSnackbar(text: LocalizationKeys.logoutError.tr);
      update();
    }
  }

  /// Checks if user is currently logged in
  Future<bool> isUserLoggedIn() async {
    try {
      return await _sessionManager.isUserLoggedIn();
    } catch (e) {
      return false;
    }
  }

  /// Manually refreshes the token (for testing purposes)
  Future<bool> refreshToken() async {
    try {
      authState = AuthState.loading;
      update();

      final success = await _tokenManager.refreshToken();

      if (success) {
        showSuccessSnackbar(
          text: LocalizationKeys.tokenRefreshedSuccessfully.tr,
        );
      }

      authState = AuthState.success;
      update();
      return success;
    } catch (e) {
      authState = AuthState.failure;
      showFailSnackbar(text: LocalizationKeys.errorDuringTokenRefresh.tr);
      update();
      return false;
    }
  }
}
