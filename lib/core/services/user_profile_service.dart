import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/features/login/data/models/user_profile_model.dart';
import 'package:healtho_gym/core/constant/db_constants.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'dart:async';
import 'dart:typed_data';

class UserProfileService {
  final SupabaseClient _supabase = SupabaseService.supabase;
  
  // Get user profile by user ID
  Future<UserProfileModel?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from(DBConstants.userProfilesTable)
          .select()
          .eq(DBConstants.profileUserId, userId)
          .maybeSingle();
      
      if (response == null) {
        LoggerUtil.info('No profile found for user: $userId');
        return null;
      }
      
      LoggerUtil.info('Profile fetched for user: $userId');
      return UserProfileModel.fromJson(response);
    } catch (e, stackTrace) {
      LoggerUtil.error('Error fetching user profile', e, stackTrace);
      rethrow;
    }
  }
  
  // Create user profile
  Future<UserProfileModel> createUserProfile(UserProfileModel profile) async {
    try {
      final response = await _supabase
          .from(DBConstants.userProfilesTable)
          .insert(profile.toJson())
          .select()
          .single();
      
      LoggerUtil.info('Profile created for user: ${profile.userId}');
      return UserProfileModel.fromJson(response);
    } catch (e, stackTrace) {
      LoggerUtil.error('Error creating user profile', e, stackTrace);
      rethrow;
    }
  }
  
  // Update user profile
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    try {
      // Update the update_date field
      final updatedProfile = profile.copyWith(
        updateDate: DateTime.now(),
      );
      
      final response = await _supabase
          .from(DBConstants.userProfilesTable)
          .update(updatedProfile.toJson())
          .eq(DBConstants.profileId, profile.id)
          .select()
          .single();
      
      LoggerUtil.info('Profile updated for user: ${profile.userId}');
      return UserProfileModel.fromJson(response);
    } catch (e, stackTrace) {
      LoggerUtil.error('Error updating user profile', e, stackTrace);
      rethrow;
    }
  }
  
  // Create or update user profile (upsert)
  Future<UserProfileModel> upsertUserProfile(UserProfileModel profile) async {
    try {
      // Update the update_date field
      final updatedProfile = profile.copyWith(
        updateDate: DateTime.now(),
      );
      
      final response = await _supabase
          .from(DBConstants.userProfilesTable)
          .upsert(updatedProfile.toJson())
          .select()
          .single();
      
      LoggerUtil.info('Profile upserted for user: ${profile.userId}');
      return UserProfileModel.fromJson(response);
    } catch (e, stackTrace) {
      LoggerUtil.error('Error upserting user profile', e, stackTrace);
      rethrow;
    }
  }
  
  // Delete user profile
  Future<void> deleteUserProfile(String profileId) async {
    try {
      await _supabase
          .from(DBConstants.userProfilesTable)
          .delete()
          .eq(DBConstants.profileId, profileId);
      
      LoggerUtil.info('Profile deleted: $profileId');
    } catch (e, stackTrace) {
      LoggerUtil.error('Error deleting user profile', e, stackTrace);
      rethrow;
    }
  }
  
  // Upload profile picture
  Future<String> uploadProfilePicture(String userId, Uint8List fileBytes, String fileName) async {
    try {
      final String path = 'profiles/$userId/$fileName';
      
      await _supabase.storage
          .from('profile-pictures')
          .uploadBinary(path, fileBytes);
      
      final String publicUrl = _supabase.storage
          .from('profile-pictures')
          .getPublicUrl(path);
      
      LoggerUtil.info('Profile picture uploaded for user: $userId');
      return publicUrl;
    } catch (e, stackTrace) {
      LoggerUtil.error('Error uploading profile picture', e, stackTrace);
      rethrow;
    }
  }
} 