import 'package:equatable/equatable.dart';
import 'package:healtho_gym/dashboard/features/user/data/models/user_with_profile.dart';

class UserManagementState extends Equatable {
  final List<UserWithProfile> users;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final bool hasMoreItems;
  final int page;
  final int limit;

  const UserManagementState({
    this.users = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = '',
    this.hasMoreItems = false,
    this.page = 1,
    this.limit = 20,
  });

  // Create initial state
  factory UserManagementState.initial() {
    return const UserManagementState();
  }

  // Create loading state
  factory UserManagementState.loading() {
    return const UserManagementState(
      isLoading: true,
    );
  }

  // Create loaded state
  factory UserManagementState.loaded(
    List<UserWithProfile> users, {
    bool hasMoreItems = false,
    int page = 1,
    int limit = 20,
  }) {
    return UserManagementState(
      users: users,
      isLoading: false,
      hasMoreItems: hasMoreItems,
      page: page,
      limit: limit,
    );
  }

  // Create loading more state
  factory UserManagementState.loadingMore(
    List<UserWithProfile> currentUsers,
    int currentPage,
    int limit,
  ) {
    return UserManagementState(
      users: currentUsers,
      isLoading: true,
      page: currentPage,
      limit: limit,
    );
  }

  // Create error state
  factory UserManagementState.error(String message) {
    return UserManagementState(
      hasError: true,
      errorMessage: message,
    );
  }

  // Create copyWith
  UserManagementState copyWith({
    List<UserWithProfile>? users,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? hasMoreItems,
    int? page,
    int? limit,
  }) {
    return UserManagementState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
        users,
        isLoading,
        hasError,
        errorMessage,
        hasMoreItems,
        page,
        limit,
      ];
} 