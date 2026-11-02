import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../bindings/initial_binding.dart';
import '../core/constants/app_config.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_snackbar.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

/// Root widget: Arabic (RTL) light-only app.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      locale: AppConfig.locale,
      supportedLocales: const <Locale>[AppConfig.locale],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.initial,
      getPages: AppPages.pages,
      scaffoldMessengerKey: AppSnackbar.messengerKey,
    );
  }
}
