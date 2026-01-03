import 'package:pos_pharma_app/core/domain/models/user_model.dart';

enum LoginMethod {
  credentials,
  google,
  facebook,
  apple;

  const LoginMethod();
}

class AuthCredentials {
  final String access;
  final String refresh;
  final UserModel user;
  final LoginMethod loginMethod;

  AuthCredentials({
    required this.access,
    required this.refresh,
    required this.user,
    required this.loginMethod,
  });

  factory AuthCredentials.fromJson(
    Map<String, dynamic> json,
    LoginMethod loginMethod,
  ) {
    return AuthCredentials(
      access: json['access'],
      refresh: json['refresh'],
      user: UserModel.fromJson(json['user']),
      loginMethod: loginMethod,
    );
  }

  @override
  String toString() {
    return 'AuthCredentials(access: $access, refresh: $refresh, user: ${user.toString()}';
  }
}
