import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/locale/locale_provider.dart';
import 'package:healtho_gym/core/preferences/app_preferences.dart';
import 'package:healtho_gym/core/routes/app_routes.dart';
import 'package:healtho_gym/core/theme/app_theme.dart';
import 'package:healtho_gym/core/theme/theme_provider.dart';
import 'package:healtho_gym/features/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
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
