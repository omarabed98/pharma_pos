import 'package:get/get.dart';

import '../../../core/cache/secure_storage_service.dart';
import '../../../core/services/session_manager_service.dart';
import '../../../core/services/token_manager_service.dart';
import '../data/data_source/auth_remote_data_source.dart';
import '../data/repository/auth_repo.dart';
import '../presentation/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSourceAbstraction>(
      () => AuthRemoteDataSource(Get.find()),
    );

    Get.lazyPut<AuthRepositoryAbstraction>(
      () => AuthRepository(Get.find(), SecureStorageService()),
    );

    Get.lazyPut<AuthController>(
      () => AuthController(
        repository: Get.find<AuthRepositoryAbstraction>(),
        tokenManager: Get.find<TokenManagerService>(),
        sessionManager: Get.find<SessionManagerService>(),
      ),
    );
  }
}
