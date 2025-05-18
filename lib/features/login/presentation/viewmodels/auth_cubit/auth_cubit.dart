import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/login/data/models/user_model.dart';
import 'package:healtho_gym/features/login/data/repositories/auth_repository.dart';
import 'package:healtho_gym/core/utils/error_util.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_state.dart' as app_state;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCubit extends Cubit<app_state.AuthState> {
  final AuthRepository _authRepository = sl<AuthRepository>();
  StreamSubscription? _authStateSubscription;
  
  AuthCubit() : super(app_state.AuthState.initial()) {
    _checkCurrentAuthState();
    _setupAuthListener();
  }
  
  void _setupAuthListener() {
    // Listen to auth state changes
    _authStateSubscription = _authRepository.authStateChanges().listen((event) {
      if (isClosed) return; // Prevent emitting after closed
      
      if (event.event == AuthChangeEvent.signedIn) {
        if (event.session?.user != null) {
          final user = UserModel(
            id: event.session!.user.id,
            email: event.session!.user.email!,
            createdAt: DateTime.parse(event.session!.user.createdAt),
          );
          emit(app_state.AuthState.authenticated(user));
        }
      } else if (event.event == AuthChangeEvent.signedOut) {
        emit(app_state.AuthState.unauthenticated());
      }
    });
  }
  
  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
  
  // Getters
  bool get isLoggedIn => _authRepository.isLoggedIn;
  
  // Check the current auth state
  void _checkCurrentAuthState() {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      final user = UserModel(
        id: currentUser.id,
        email: currentUser.email!,
        createdAt: DateTime.parse(currentUser.createdAt),
      );
      emit(app_state.AuthState.authenticated(user));
    } else {
      emit(app_state.AuthState.unauthenticated());
    }
  }
  
  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      emit(app_state.AuthState.authenticating());
      
      final user = await _authRepository.signIn(email, password);
      
      if (user != null) {
        emit(app_state.AuthState.authenticated(user));
        return true;
      } else {
        emit(app_state.AuthState.error('بيانات تسجيل الدخول غير صحيحة. يرجى التحقق من البريد الإلكتروني وكلمة المرور.'));
        return false;
      }
    } catch (e) {
      if (isClosed) return false; // Prevent emitting after closed
      
      final errorMessage = ErrorUtil.getAuthErrorMessage(e);
      LoggerUtil.error('Cubit: Sign in error', e);
      emit(app_state.AuthState.error(errorMessage));
      return false;
    }
  }
  
  // Sign up with email and password
  Future<bool> signUp(String email, String password) async {
    try {
      emit(app_state.AuthState.authenticating());
      
      final user = await _authRepository.signUp(email, password);
      
      if (user != null) {
        emit(app_state.AuthState.authenticated(user));
        return true;
      } else {
        emit(app_state.AuthState.error('تعذر إنشاء الحساب. يرجى المحاولة مرة أخرى.'));
        return false;
      }
    } catch (e) {
      if (isClosed) return false; // Prevent emitting after closed
      
      final errorMessage = ErrorUtil.getAuthErrorMessage(e);
      LoggerUtil.error('Cubit: Sign up error', e);
      emit(app_state.AuthState.error(errorMessage));
      return false;
    }
  }
  
  // Sign out
  Future<bool> signOut() async {
    try {
      await _authRepository.signOut();
      
      if (!isClosed) {
        emit(app_state.AuthState.unauthenticated());
      }
      return true;
    } catch (e) {
      if (isClosed) return false; // Prevent emitting after closed
      
      final errorMessage = ErrorUtil.getAuthErrorMessage(e);
      LoggerUtil.error('Cubit: Sign out error', e);
      emit(app_state.AuthState.error(errorMessage));
      return false;
    }
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      // Keep current state but start operation
      await _authRepository.resetPassword(email);
      return true;
    } catch (e) {
      if (isClosed) return false; // Prevent emitting after closed
      
      final errorMessage = ErrorUtil.getAuthErrorMessage(e);
      LoggerUtil.error('Cubit: Reset password error', e);
      emit(app_state.AuthState.error(errorMessage));
      return false;
    }
  }
} 