import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();
  
  factory AppPreferences() => _instance;
  
  AppPreferences._internal();
  
  static SharedPreferences? _preferences;
  
  // Keys
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String isDarkModeKey = 'is_dark_mode';
  static const String languageCodeKey = 'language_code';
  
  // Initialize
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }
  
  // Onboarding
  Future<bool> setHasSeenOnboarding(bool value) async {
    return await _preferences?.setBool(hasSeenOnboardingKey, value) ?? false;
  }
  
  bool get hasSeenOnboarding => _preferences?.getBool(hasSeenOnboardingKey) ?? false;
  
  // Theme
  Future<bool> setIsDarkMode(bool value) async {
    return await _preferences?.setBool(isDarkModeKey, value) ?? false;
  }
  
  bool get isDarkMode => _preferences?.getBool(isDarkModeKey) ?? false;
  
  // Language
  Future<bool> setLanguageCode(String value) async {
    return await _preferences?.setString(languageCodeKey, value) ?? false;
  }
  
  String get languageCode => _preferences?.getString(languageCodeKey) ?? 'ar';
  
  // Clear all preferences
  Future<bool> clear() async {
    return await _preferences?.clear() ?? false;
  }
} 