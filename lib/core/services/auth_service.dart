import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseService.supabase;

  // Check if user is logged in
  bool get isLoggedIn => _supabase.auth.currentUser != null;
  
  // Get current user
  User? get currentUser => _supabase.auth.currentUser;
  
  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;
  
  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      LoggerUtil.info('User signed in: ${response.user?.email}');
      return response;
    } catch (e, stackTrace) {
      LoggerUtil.error('Error signing in', e, stackTrace);
      rethrow;
    }
  }
  
  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      LoggerUtil.info('User signed up: ${response.user?.email}');
      return response;
    } catch (e, stackTrace) {
      LoggerUtil.error('Error signing up', e, stackTrace);
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      LoggerUtil.info('User signed out');
    } catch (e, stackTrace) {
      LoggerUtil.error('Error signing out', e, stackTrace);
      rethrow;
    }
  }
  
  // Password reset
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      LoggerUtil.info('Password reset email sent to $email');
    } catch (e, stackTrace) {
      LoggerUtil.error('Error sending password reset email', e, stackTrace);
      rethrow;
    }
  }
  
  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      LoggerUtil.info('Password updated for user: ${response.user?.email}');
      return response;
    } catch (e, stackTrace) {
      LoggerUtil.error('Error updating password', e, stackTrace);
      rethrow;
    }
  }
  
  // Listen to auth state changes
  Stream<AuthState> authStateChanges() {
    return _supabase.auth.onAuthStateChange;
  }
} 