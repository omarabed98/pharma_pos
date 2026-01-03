import 'package:fl_country_code_picker/fl_country_code_picker.dart' as flc;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:pos_pharma_app/core/domain/routing/app_navigator.dart';
import 'package:pos_pharma_app/core/domain/routing/app_routes.dart';

import '../core/binding/network_core_binding.dart';
import '../core/cache/local_storage_service.dart';
import '../core/cache/secure_storage_service.dart';
import '../core/presentation/localization/app_localization.dart';
import '../core/presentation/localization/language_registry.dart';
import '../core/presentation/theme/app_theme.dart';
import '../core/utils/app_utils.dart';

Future<void> mainApp() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Added to fix the loading white screen at the beginning,
  /// because the design splash is most probably dark color very
  /// contrasted from white
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await LocalStorageService().init();
  await SecureStorageService().init();
  await AppUtils.init(LocalStorageService());

  FlutterNativeSplash.remove();

  runApp(const AppWidget());
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sound Level',
      translations: AppLocalization(),
      debugShowCheckedModeBanner: false,
      locale: Locale(LocalStorageService().locale),
      localizationsDelegates: const [
        flc.CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageRegistry.supportedLocales(),
      fallbackLocale: const Locale('ar'),
      theme: AppTheme().light,
      darkTheme: AppTheme().dark,
      themeMode: LocalStorageService().themeMode,
      getPages: AppNavigator.instance.routes,
      initialBinding: NetworkCoreBinding(),
      initialRoute: AppRoutes.splash,
      builder: (context, child) {
        final base = context.isPhone
            ? child!
            : Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: child!,
                ),
              );
        return base;
      },
    );
  }
}
