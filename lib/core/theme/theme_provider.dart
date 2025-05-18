import 'package:flutter/material.dart';
import 'package:healtho_gym/core/preferences/app_preferences.dart';
import 'package:healtho_gym/core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final _preferences = AppPreferences();
  ThemeMode _themeMode = ThemeMode.light;
  bool _initialized = false;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    final isDark = _preferences.isDarkMode;
    
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _initialized = true;
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    
    await _preferences.setIsDarkMode(_themeMode == ThemeMode.dark);
    
    notifyListeners();
  }
  
  Future<void> setDarkMode(bool isDark) async {
    if (_themeMode == ThemeMode.dark && isDark) return;
    if (_themeMode == ThemeMode.light && !isDark) return;
    
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    await _preferences.setIsDarkMode(isDark);
    
    notifyListeners();
  }
} 