import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/locale/locale_provider.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/onboarding_screen.dart';
import 'package:healtho_gym/screen/login/sign_in_screen.dart';
import 'package:healtho_gym/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    
    // Simulate a loading duration
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // Check if user is already logged in
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      if (authViewModel.isLoggedIn) {
        // Navigate to home screen if logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TopTabViewScreen()),
        );
      } else {
        // Navigate to onboarding or sign in screen
        if (!hasSeenOnboarding) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return Directionality(
      textDirection: localeProvider.isArabic ? TextDirection.rtl : TextDirection.ltr,
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
              const SizedBox(height: 50),
              // Loading indicator
              CircularProgressIndicator(
                color: TColor.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
