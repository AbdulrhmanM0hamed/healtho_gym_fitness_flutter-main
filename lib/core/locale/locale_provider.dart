import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');
  bool _initialized = false;
  
  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isArabic => _locale.languageCode == 'ar';
  bool get isEnglish => _locale.languageCode == 'en';
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'ar';
    
    _locale = Locale(languageCode);
    _initialized = true;
    notifyListeners();
  }
  
  Future<void> setLocale(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) return;
    
    _locale = locale;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    
    notifyListeners();
  }
  
  Future<void> toggleLocale() async {
    final newLanguageCode = _locale.languageCode == 'ar' ? 'en' : 'ar';
    await setLocale(Locale(newLanguageCode));
  }
  
  Future<void> setArabic() async {
    await setLocale(const Locale('ar'));
  }
  
  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }
} 