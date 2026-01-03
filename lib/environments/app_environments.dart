import 'package:flutter_flavor/flutter_flavor.dart';

enum AppEnvironments {
  production;

  Map<String, dynamic> get variables {
    switch (this) {
      case AppEnvironments.production:
        return {'BASE_URL': 'http://82.212.106.189:9077'};
    }
  }
}

class AppEnvironmentHelper {
  AppEnvironments get getEnvironment =>
      _environmentNameMapper(FlavorConfig.instance.name!);

  getEnvironmentVariable(String variableName) {
    return getEnvironment.variables[variableName];
  }

  AppEnvironments _environmentNameMapper(String flavorName) {
    if (flavorName == AppEnvironments.production.name) {
      return AppEnvironments.production;
    }
    throw UnimplementedError();
  }
}
