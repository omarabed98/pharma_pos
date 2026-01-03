import 'package:dartz/dartz.dart';

import '../../../../core/data/networking/data/network_request.dart';
import '../../../../core/data/networking/data/network_response.dart';
import '../../../../core/data/networking/data/network_router.dart';
import '../../../../core/data/networking/network_adapter.dart';
import '../../../../core/domain/errors/failure.dart';
import '../../domain/models/auth_credentials.dart';

abstract class AuthRemoteDataSourceAbstraction {
  Future<Either<Failure, AuthCredentials>> manualLogin(
    String username,
    String password,
    String imei,
  );
}

class AuthRemoteDataSource implements AuthRemoteDataSourceAbstraction {
  final NetworkAdapterAbstraction _networkAdapter;

  AuthRemoteDataSource(this._networkAdapter);

  @override
  Future<Either<Failure, AuthCredentials>> manualLogin(
    String username,
    String password,
    String imei,
  ) async {
    final request = NetworkRequest(
      route: NetworkRouter.login,
      requestType: RequestType.post,
      data: {'username': username, 'password': password, 'imei': imei},
    );
    final response = await _networkAdapter.request(request);
    if (response.status == NetworkResponseStatus.success) {
      return Right(
        AuthCredentials.fromJson(response.data, LoginMethod.credentials),
      );
    } else {
      return Left(response.failure!);
    }
  }
}
