import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/models/user_model.dart';
import 'package:healtho_gym/services/auth_service.dart';
import 'package:healtho_gym/utils/logger_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthService _authService = sl<AuthService>();
  
  bool get isLoggedIn => _authService.isLoggedIn;
  
  User? get currentUser => _authService.currentUser;
  
  // Sign in with email and password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await _authService.signInWithEmailPassword(email, password);
      if (response.user != null) {
        return UserModel(
          id: response.user!.id,
          email: response.user!.email!,
          createdAt: DateTime.parse(response.user!.createdAt),
        );
      }
      return null;
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error signing in', e, stackTrace);
      rethrow;
    }
  }
  
  // Sign up with email and password
  Future<UserModel?> signUp(String email, String password) async {
    try {
      final response = await _authService.signUpWithEmailPassword(email, password);
      if (response.user != null) {
        return UserModel(
          id: response.user!.id,
          email: response.user!.email!,
          createdAt: DateTime.parse(response.user!.createdAt),
        );
      }
      return null;
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error signing up', e, stackTrace);
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error signing out', e, stackTrace);
      rethrow;
    }
  }
  
  // Password reset
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error sending password reset email', e, stackTrace);
      rethrow;
    }
  }
  
  // Listen to auth state changes
  Stream<AuthState> authStateChanges() {
    return _authService.authStateChanges();
  }
} 