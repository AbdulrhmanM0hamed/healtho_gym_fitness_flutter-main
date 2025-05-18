import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/dashboard/features/user/data/models/user_with_profile.dart';
import 'package:healtho_gym/dashboard/features/user/data/services/user_management_service.dart';

class UserManagementRepository {
  final UserManagementService _userManagementService = sl<UserManagementService>();
  
  // Get users with their profiles
  Future<List<UserWithProfile>> getUsers({int page = 1, int limit = 20}) async {
    try {
      return await _userManagementService.getUsers(page: page, limit: limit);
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error fetching users', e, stackTrace);
      rethrow;
    }
  }
  
  // Get number of users
  Future<int> getUsersCount() async {
    try {
      return await _userManagementService.getUsersCount();
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error getting users count', e, stackTrace);
      rethrow;
    }
  }
  
  // Check if there are more users to load
  Future<bool> hasMoreUsers(int currentPage, int limit) async {
    try {
      final total = await getUsersCount();
      final loadedCount = currentPage * limit;
      return loadedCount < total;
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error checking for more users', e, stackTrace);
      rethrow;
    }
  }
  
  // Toggle admin status for a user
  Future<void> toggleAdminStatus(String profileId, String userId, bool isAdmin) async {
    try {
      await _userManagementService.toggleAdminStatus(profileId, userId, isAdmin);
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error toggling admin status', e, stackTrace);
      rethrow;
    }
  }
} 