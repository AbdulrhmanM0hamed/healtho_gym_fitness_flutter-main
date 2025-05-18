import 'package:flutter/material.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/login/data/models/user_model.dart';
import 'package:healtho_gym/features/login/data/repositories/auth_repository.dart';
import 'package:healtho_gym/core/utils/error_util.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error,
}

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = sl<AuthRepository>();
  
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String _errorMessage = '';
  dynamic _rawError;
  
  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String get errorMessage => _errorMessage;
  dynamic get rawError => _rawError;
  bool get isLoggedIn => _authRepository.isLoggedIn;
  
  AuthViewModel() {
    // Check if user is already logged in
    _checkCurrentAuthState();
    
    // Listen to auth state changes
    _authRepository.authStateChanges().listen((state) {
      if (state.event == AuthChangeEvent.signedIn) {
        _status = AuthStatus.authenticated;
        _user = state.session?.user != null 
          ? UserModel(
              id: state.session!.user.id,
              email: state.session!.user.email!,
              createdAt: DateTime.parse(state.session!.user.createdAt),
            )
          : null;
      } else if (state.event == AuthChangeEvent.signedOut) {
        _status = AuthStatus.unauthenticated;
        _user = null;
      }
      notifyListeners();
    });
  }
  
  // Check the current auth state
  void _checkCurrentAuthState() {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      _status = AuthStatus.authenticated;
      _user = UserModel(
        id: currentUser.id,
        email: currentUser.email!,
        createdAt: DateTime.parse(currentUser.createdAt),
      );
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
  
  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = '';
      _rawError = null;
      notifyListeners();
      
      final user = await _authRepository.signIn(email, password);
      
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'بيانات تسجيل الدخول غير صحيحة. يرجى التحقق من البريد الإلكتروني وكلمة المرور.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _rawError = e;
      _errorMessage = ErrorUtil.getAuthErrorMessage(e);
      LoggerUtil.error('ViewModel: Sign in error', e);
      notifyListeners();
      return false;
    }
  }
  
  // Sign up with email and password
  Future<bool> signUp(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = '';
      _rawError = null;
      notifyListeners();
      
      final user = await _authRepository.signUp(email, password);
      
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'تعذر إنشاء الحساب. يرجى المحاولة مرة أخرى.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _rawError = e;
      _errorMessage = ErrorUtil.getAuthErrorMessage(e);
      LoggerUtil.error('ViewModel: Sign up error', e);
      notifyListeners();
      return false;
    }
  }
  
  // Sign out
  Future<bool> signOut() async {
    try {
      await _authRepository.signOut();
      _status = AuthStatus.unauthenticated;
      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _rawError = e;
      _errorMessage = ErrorUtil.getAuthErrorMessage(e);
      LoggerUtil.error('ViewModel: Sign out error', e);
      notifyListeners();
      return false;
    }
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _errorMessage = '';
      _rawError = null;
      notifyListeners();
      
      await _authRepository.resetPassword(email);
      notifyListeners();
      return true;
    } catch (e) {
      _rawError = e;
      _errorMessage = ErrorUtil.getAuthErrorMessage(e);
      LoggerUtil.error('ViewModel: Reset password error', e);
      notifyListeners();
      return false;
    }
  }
} 