import 'package:dartz/dartz.dart' show Either;

import '../../../../core/cache/secure_storage_service.dart';
import '../../../../core/domain/errors/failure.dart';
import '../../domain/models/auth_credentials.dart';
import '../data_source/auth_remote_data_source.dart';

abstract class AuthRepositoryAbstraction {
  Future<Either<Failure, AuthCredentials>> manualLogin(
    String username,
    String password,
    String imei,
  );

  /// Removed access token from cache if its null, and saves if non null
  Future<void> setAccessToken({String? accessToken, String? refreshToken});
}

class AuthRepository implements AuthRepositoryAbstraction {
  final AuthRemoteDataSourceAbstraction _remoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepository(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, AuthCredentials>> manualLogin(
    String username,
    String password,
    String imei,
  ) => _remoteDataSource.manualLogin(username, password, imei);

  @override
  Future<void> setAccessToken({
    String? accessToken,
    String? refreshToken,
  }) async {
    if (accessToken != null && accessToken.isNotEmpty) {
      // Save access token
      await _secureStorage.cacheAccessToken(accessToken);
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      // Save refresh token
      await _secureStorage.cacheRefreshToken(refreshToken);
    }

    // If neither token is provided or both are empty, remove both from storage
    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty)) {
      _secureStorage.clearAllTokens();
    }
  }
}
