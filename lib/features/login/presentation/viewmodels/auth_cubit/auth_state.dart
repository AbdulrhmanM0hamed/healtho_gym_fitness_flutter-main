import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/login/data/models/user_model.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String errorMessage;
  
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage = '',
  });
  
  bool get isLoading => status == AuthStatus.authenticating;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError => status == AuthStatus.error;
  
  // Initial state factory constructor
  factory AuthState.initial() => const AuthState(
    status: AuthStatus.initial, 
    user: null, 
    errorMessage: '',
  );
  
  // Authenticating state factory constructor
  factory AuthState.authenticating() => const AuthState(
    status: AuthStatus.authenticating, 
    user: null, 
    errorMessage: '',
  );
  
  // Authenticated state factory constructor
  factory AuthState.authenticated(UserModel user) => AuthState(
    status: AuthStatus.authenticated, 
    user: user, 
    errorMessage: '',
  );
  
  // Unauthenticated state factory constructor
  factory AuthState.unauthenticated() => const AuthState(
    status: AuthStatus.unauthenticated, 
    user: null, 
    errorMessage: '',
  );
  
  // Error state factory constructor
  factory AuthState.error(String errorMessage) => AuthState(
    status: AuthStatus.error, 
    user: null, 
    errorMessage: errorMessage,
  );
  
  // copyWith method for creating new instances
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, user, errorMessage];
} 