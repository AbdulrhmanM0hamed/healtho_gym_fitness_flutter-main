import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/locale/locale_provider.dart';
import 'package:healtho_gym/core/preferences/app_preferences.dart';
import 'package:healtho_gym/core/routes/app_routes.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final _preferences = AppPreferences();
  int _currentPage = 0;
  
  final List<String> _images = [
    "assets/img/in_1.png",
    "assets/img/in_2.png",
    "assets/img/in_3.png",
  ];
  
  @override
  void initState() {
    super.initState();
    // Ensure locale is set to Arabic by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      if (localeProvider.languageCode != 'ar') {
        localeProvider.setArabic();
      }
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _completeOnboarding() async {
    // Mark onboarding as seen
    await _preferences.setHasSeenOnboarding(true);
    
    if (mounted) {
      // Navigate to sign in screen
      AppRoutes.navigateAndClearStack(context, AppRoutes.signIn);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isLastPage = _currentPage == 2;
    
    return Directionality(
      textDirection: TextDirection.rtl,  // Always use RTL for Arabic
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildOnboardingPage(
                      image: _images[0],
                      title: locale.onboardingTitle1,
                      description: locale.onboardingDesc1,
                    ),
                    _buildOnboardingPage(
                      image: _images[1],
                      title: locale.onboardingTitle2,
                      description: locale.onboardingDesc2,
                    ),
                    _buildOnboardingPage(
                      image: _images[2],
                      title: locale.onboardingTitle3,
                      description: locale.onboardingDesc3,
                    ),
                  ],
                ),
              ),
              
              // Page indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: index == _currentPage ? 25 : 10,
                      decoration: BoxDecoration(
                        color: index == _currentPage 
                            ? TColor.primary 
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip button
                    if (!isLastPage)
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          locale.skip,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 80),
                      
                    // Next or Get Started button
                    SizedBox(
                      width: 150,
                      child: RoundButton(
                        title: isLastPage ? locale.getStarted : locale.next,
                        onPressed: () {
                          if (isLastPage) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: TColor.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
} 