import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/preferences/app_preferences.dart';
import 'package:healtho_gym/core/routes/app_routes.dart';
import 'package:healtho_gym/features/login/data/repositories/auth_repository.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _preferences = AppPreferences();
  final _authRepository = sl<AuthRepository>();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate a loading duration
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // Check if user is already logged in
      final isLoggedIn = _authRepository.isLoggedIn;
      
      if (isLoggedIn) {
        // Navigate to home screen if logged in
        AppRoutes.navigateAndClearStack(context, AppRoutes.home);
      } else {
        // Navigate to onboarding or sign in screen
        if (!_preferences.hasSeenOnboarding) {
          AppRoutes.navigateAndClearStack(context, AppRoutes.onboarding);
        } else {
          AppRoutes.navigateAndClearStack(context, AppRoutes.signIn);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    
    return Directionality(
      textDirection: TextDirection.rtl, // Always RTL for Arabic
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "assets/img/app_logo.png",
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(height: 30),
              // App name
              Text(
                locale.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: TColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Slogan
              Text(
                "صحتك أولوية لدينا",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
