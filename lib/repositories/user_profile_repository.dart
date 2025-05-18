import 'dart:typed_data';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/models/user_profile_model.dart';
import 'package:healtho_gym/core/services/user_profile_service.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:uuid/uuid.dart';

class UserProfileRepository {
  final UserProfileService _userProfileService = sl<UserProfileService>();
  
  // Get user profile by user ID
  Future<UserProfileModel?> getUserProfile(String userId) async {
    try {
      return await _userProfileService.getUserProfile(userId);
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error fetching user profile', e, stackTrace);
      rethrow;
    }
  }
  
  // Create user profile
  Future<UserProfileModel> createUserProfile({
    required String userId,
    String? fullName,
    int? age,
    double? height,
    double? weight,
    String? goal,
    String? fitnessLevel,
  }) async {
    try {
      final profile = UserProfileModel(
        id: const Uuid().v4(),
        userId: userId,
        fullName: fullName,
        age: age,
        height: height,
        weight: weight,
        goal: goal,
        fitnessLevel: fitnessLevel,
        updateDate: DateTime.now(),
      );
      
      return await _userProfileService.createUserProfile(profile);
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error creating user profile', e, stackTrace);
      rethrow;
    }
  }
  
  // Update user profile
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    try {
      return await _userProfileService.updateUserProfile(profile);
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error updating user profile', e, stackTrace);
      rethrow;
    }
  }
  
  // Update specific profile fields
  Future<UserProfileModel?> updateProfileFields({
    required String userId,
    String? fullName,
    int? age,
    double? height,
    double? weight,
    String? goal,
    String? fitnessLevel,
  }) async {
    try {
      final currentProfile = await getUserProfile(userId);
      
      if (currentProfile == null) {
        return createUserProfile(
          userId: userId,
          fullName: fullName,
          age: age,
          height: height,
          weight: weight,
          goal: goal,
          fitnessLevel: fitnessLevel,
        );
      }
      
      final updatedProfile = currentProfile.copyWith(
        fullName: fullName,
        age: age,
        height: height,
        weight: weight,
        goal: goal,
        fitnessLevel: fitnessLevel,
      );
      
      return await _userProfileService.updateUserProfile(updatedProfile);
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error updating profile fields', e, stackTrace);
      rethrow;
    }
  }
  
  // Upload profile picture and update profile
  Future<UserProfileModel?> uploadProfilePicture(String userId, Uint8List imageBytes, String fileName) async {
    try {
      final currentProfile = await getUserProfile(userId);
      if (currentProfile == null) {
        throw Exception('Profile not found for user: $userId');
      }
      
      final pictureUrl = await _userProfileService.uploadProfilePicture(
        userId, 
        imageBytes, 
        fileName,
      );
      
      final updatedProfile = currentProfile.copyWith(
        profilePictureUrl: pictureUrl,
      );
      
      return await _userProfileService.updateUserProfile(updatedProfile);
    } catch (e, stackTrace) {
      LoggerUtil.error('Repository: Error uploading profile picture', e, stackTrace);
      rethrow;
    }
  }
} 