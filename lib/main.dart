import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/locale/locale_provider.dart';
import 'package:healtho_gym/core/preferences/app_preferences.dart';
import 'package:healtho_gym/core/routes/app_routes.dart';
import 'package:healtho_gym/core/theme/app_theme.dart';
import 'package:healtho_gym/core/theme/theme_provider.dart';
import 'package:healtho_gym/dashboard/app/dashboard_app.dart';
import 'package:healtho_gym/features/splash/splash_screen.dart';
import 'package:provider/provider.dart';

// To use the dashboard, comment out this line and uncomment the next line
// void main() async {
//   mainMobile();
// }

// To use the dashboard, uncomment this line and comment out the previous main
void main() async {
  mainMobile();
}

// Mobile application entry point
void mainMobile() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Preferences
  await AppPreferences().init();
  
  // Initialize ServiceLocator
  await ServiceLocator.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..initialize()),
      ],
      child: const MyApp(),
    ),
  );
}

// Dashboard application entry point
void mainDashboard() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize ServiceLocator
  await ServiceLocator.init();
  
  // This would be a better approach but requires importing the dashboard directly
  // runApp(const DashboardApp());
  
  // Instead, for now, show a message telling the user to use dashboard_main.dart
  runApp(DashboardApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return MaterialApp(
      title: 'Healtho Gym',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Always start with splash screen
      home: const SplashScreen(),
      // Use the routes defined in AppRoutes
      routes: AppRoutes.routes,
      // Use the onGenerateRoute from AppRoutes
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
