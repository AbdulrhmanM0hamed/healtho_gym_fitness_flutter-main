import 'package:flutter/material.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/onboarding_screen.dart';
import 'package:healtho_gym/screen/login/sign_in_screen.dart';
import 'package:healtho_gym/screen/login/sign_up_screen.dart';
import 'package:healtho_gym/screen/login/splash_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';
  
  // Route map
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),
    home: (context) => const TopTabViewScreen(),
  };
  
  // onGenerateRoute for handling dynamic routes and params
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Extract route name
    final name = settings.name;
    final arguments = settings.arguments;
    
    // Default transition animation
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        switch (name) {
          case splash:
            return const SplashScreen();
          case onboarding:
            return const OnboardingScreen();
          case signIn:
            return const SignInScreen();
          case signUp:
            return const SignUpScreen();
          case home:
            return const TopTabViewScreen();
          default:
            // If route not found, return splash screen
            return const SplashScreen();
        }
      },
    );
  }
  
  // Navigate to a named route
  static Future<dynamic> navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }
  
  // Navigate and replace current route
  static Future<dynamic> navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }
  
  // Navigate and clear all previous routes
  static Future<dynamic> navigateAndClearStack(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil(
      context, 
      routeName, 
      (route) => false,
      arguments: arguments,
    );
  }
} 