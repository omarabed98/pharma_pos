import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:pos_pharma_app/environments/app_environments.dart';

import 'environments/_main.dart';

void main() {
  FlavorConfig(
    name: AppEnvironments.production.name,
    variables: AppEnvironments.production.variables,
    location: BannerLocation.bottomEnd,
  );

  mainApp();
}
