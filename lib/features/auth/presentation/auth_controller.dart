import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/cache/local_storage_service.dart';
import '../../../core/domain/models/user_model.dart';
import '../../../core/domain/routing/app_routes.dart';
import '../../../core/domain/utils/alerts.dart';
import '../../../core/presentation/localization/localization_keys.dart';
import '../../../core/services/session_manager_service.dart';
import '../../../core/services/token_manager_service.dart';
import '../../../core/utils/device_info_utils.dart';
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

  Future<void> manualLogin({
    required String email,
    required String password,
  }) async {
    // Check if baseUrl is set
    final baseUrl = LocalStorageService().baseUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      showFailSnackbar(
        text: LocalizationKeys.baseUrlRequired.tr,
        iconData: Icons.settings,
      );
      return;
    }

    // Get or fetch IMEI
    String imei = LocalStorageService().deviceImei ?? '';
    if (imei.isEmpty) {
      // If IMEI is not stored, fetch it and save it
      imei = await DeviceInfoUtils().getIMEI();
      if (imei.isNotEmpty && imei != 'unknown_device') {
        LocalStorageService().deviceImei = imei;
      }
    }

    authState = AuthState.loading;
    update([LoginScreen]);

    final response = await _repository.manualLogin(email, password, imei);
    response.fold(
      (failure) {
        authState = AuthState.failure;
        // Show specific error message for login failures
        showFailSnackbar(
          text: LocalizationKeys.loginError.tr,
          iconData: Icons.error,
        );
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
      // Save tokens to secure storage (with expiration)
      await _repository.setAccessToken(
        accessToken: credentials.access,
        refreshToken: credentials.refresh,
      );

      // Save user information to local storage
      final nameParts = credentials.name.split(' ');
      final userModel = UserModel(
        id: credentials.id.toString(),
        username: credentials.username,
        email: credentials.email,
        firstName: nameParts.isNotEmpty ? nameParts.first : null,
        lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : null,
      );
      LocalStorageService().user = userModel;

      // Reset refresh attempts counter after successful login
      _tokenManager.resetRefreshAttempts();
    }

    authState = AuthState.success;
    update([LoginScreen]);

    if (credentials != null) {
      // Navigate to dashboard after successful login
      Get.offNamed(AppRoutes.dashboard);
    }
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
