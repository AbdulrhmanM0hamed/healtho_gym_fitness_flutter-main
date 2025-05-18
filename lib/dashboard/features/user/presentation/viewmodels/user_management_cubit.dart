import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/utils/error_util.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/dashboard/features/user/data/repositories/user_management_repository.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/viewmodels/user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final UserManagementRepository _userRepository = sl<UserManagementRepository>();
  bool _isClosed = false;
  
  UserManagementCubit() : super(UserManagementState.initial());
  
  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }
  
  // Safe emit that checks if cubit is still active
  void safeEmit(UserManagementState state) {
    if (!_isClosed) {
      emit(state);
    } else {
      LoggerUtil.info('Attempted to emit state after cubit was closed');
    }
  }
  
  // Load users
  Future<void> loadUsers() async {
    try {
      safeEmit(UserManagementState.loading());
      
      final users = await _userRepository.getUsers(
        page: 1,
        limit: state.limit,
      );
      
      if (_isClosed) return;
      
      final hasMore = await _userRepository.hasMoreUsers(1, state.limit);
      
      safeEmit(UserManagementState.loaded(
        users,
        hasMoreItems: hasMore,
        page: 1,
        limit: state.limit,
      ));
    } catch (e) {
      final errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('Cubit: Error loading users', e);
      safeEmit(UserManagementState.error(errorMessage));
    }
  }
  
  // Load more users
  Future<void> loadMoreUsers() async {
    if (state.isLoading || _isClosed) return;
    
    try {
      final nextPage = state.page + 1;
      
      safeEmit(UserManagementState.loadingMore(
        state.users,
        nextPage,
        state.limit,
      ));
      
      final newUsers = await _userRepository.getUsers(
        page: nextPage,
        limit: state.limit,
      );
      
      if (_isClosed) return;
      
      final allUsers = [...state.users, ...newUsers];
      final hasMore = await _userRepository.hasMoreUsers(nextPage, state.limit);
      
      safeEmit(UserManagementState.loaded(
        allUsers,
        hasMoreItems: hasMore,
        page: nextPage,
        limit: state.limit,
      ));
    } catch (e) {
      final errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('Cubit: Error loading more users', e);
      safeEmit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: errorMessage,
      ));
    }
  }
  
  // Toggle admin status
  Future<void> toggleAdminStatus(String profileId, String userId, bool isAdmin) async {
    if (_isClosed) {
      LoggerUtil.info('Attempted to toggle admin status after cubit was closed');
      return;
    }
    
    try {
      await _userRepository.toggleAdminStatus(profileId, userId, isAdmin);
      
      if (_isClosed) return;
      
      // Update the user in the state
      final updatedUsers = state.users.map((user) {
        if (user.id == userId) {
          if (user.profile == null) {
            LoggerUtil.error('Profile not found for user: $userId');
            return user;
          }
          final updatedProfile = user.profile!.copyWith(isAdmin: isAdmin);
          return user.copyWith(profile: updatedProfile);
        }
        return user;
      }).toList();
      
      safeEmit(state.copyWith(users: updatedUsers));
    } catch (e) {
      final errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('Cubit: Error toggling admin status', e);
      safeEmit(state.copyWith(
        hasError: true,
        errorMessage: errorMessage,
      ));
    }
  }
} 