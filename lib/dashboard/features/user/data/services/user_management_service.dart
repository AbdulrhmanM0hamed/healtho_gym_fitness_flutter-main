import 'package:healtho_gym/core/constant/db_constants.dart';
import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/dashboard/features/user/data/models/user_with_profile.dart';
import 'package:healtho_gym/features/login/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementService {
  final SupabaseClient _supabase = SupabaseService.supabase;
  
  // Get all users with their profiles
  Future<List<UserWithProfile>> getUsers({int page = 1, int limit = 20}) async {
    try {
      final int offset = (page - 1) * limit;
      
      // Get profiles only and then attach the user data from auth
      final profilesResponse = await _supabase
          .from(DBConstants.userProfilesTable)
          .select()
          .range(offset, offset + limit - 1);
      
      // Create a list to store users with their profiles
      List<UserWithProfile> usersList = [];
      
      // For each profile, create a UserWithProfile object
      for (var profileData in profilesResponse) {
        UserProfileModel profile = UserProfileModel.fromJson(profileData);
        
        // Create UserWithProfile object
        // Since we don't have access to auth.users directly, we'll use the profile data
        final userWithProfile = UserWithProfile(
          id: profile.userId,
          email: null, // We can't get the email without admin access
          profile: profile,
        );
        
        usersList.add(userWithProfile);
      }
      
      LoggerUtil.info('Fetched ${usersList.length} user profiles for page $page');
      return usersList;
    } catch (e, stackTrace) {
      LoggerUtil.error('Error fetching users:', e, stackTrace);
      rethrow;
    }
  }
  
  // Get total users count - use the profiles count instead
  Future<int> getUsersCount() async {
    try {
      final response = await _supabase
          .from(DBConstants.userProfilesTable)
          .select('id');
      
      return response.length;
    } catch (e, stackTrace) {
      LoggerUtil.error('Error getting users count:', e, stackTrace);
      return 0; // Return 0 on error
    }
  }
  
  // Toggle admin status for a user
  Future<void> toggleAdminStatus(String profileId, String userId, bool isAdmin) async {
    try {
      // Check if user profile exists
      final profile = await _supabase
          .from(DBConstants.userProfilesTable)
          .select()
          .eq(DBConstants.profileId, profileId)
          .maybeSingle();
      
      if (profile == null) {
        // Create profile if it doesn't exist
        await _supabase
            .from(DBConstants.userProfilesTable)
            .insert({
              DBConstants.profileId: profileId,
              DBConstants.profileUserId: userId,
              DBConstants.isAdmin: isAdmin,
              DBConstants.updateDate: DateTime.now().toIso8601String(),
            });
        
        LoggerUtil.info('Created new profile for user $userId with admin status: $isAdmin');
      } else {
        // Update existing profile
        await _supabase
            .from(DBConstants.userProfilesTable)
            .update({
              DBConstants.isAdmin: isAdmin,
              DBConstants.updateDate: DateTime.now().toIso8601String(),
            })
            .eq(DBConstants.profileId, profileId);
        
        LoggerUtil.info('Updated admin status for user $userId to: $isAdmin');
      }
    } catch (e, stackTrace) {
      LoggerUtil.error('Error toggling admin status:', e, stackTrace);
      rethrow;
    }
  }
} 