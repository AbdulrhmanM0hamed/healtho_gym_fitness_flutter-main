import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/locale/locale_provider.dart';
import 'package:healtho_gym/core/theme/app_theme.dart';
import 'package:healtho_gym/core/theme/theme_provider.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/sign_in_screen.dart';
import 'package:healtho_gym/screen/login/splash_screen.dart';
import 'package:healtho_gym/viewmodels/auth_view_model.dart';
import 'package:healtho_gym/viewmodels/user_profile_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize ServiceLocator
  await ServiceLocator.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => sl<UserProfileViewModel>()),
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
    final authViewModel = Provider.of<AuthViewModel>(context);
    
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
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: authViewModel.status == AuthStatus.initial
          ? const SplashScreen()
          : authViewModel.isLoggedIn
              ? const TopTabViewScreen()
              : const SignInScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signin': (context) => const SignInScreen(),
        '/home': (context) => const TopTabViewScreen(),
      },
    );
  }
}
