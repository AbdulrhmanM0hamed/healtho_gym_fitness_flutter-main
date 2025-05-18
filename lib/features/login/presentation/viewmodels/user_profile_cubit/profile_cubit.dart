import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/login/data/models/user_profile_model.dart';
import 'package:healtho_gym/features/login/data/repositories/user_profile_repository.dart';
import 'package:healtho_gym/core/utils/error_util.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/user_profile_cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserProfileRepository _profileRepository = sl<UserProfileRepository>();
  
  ProfileCubit() : super(ProfileState.initial());
  
  // Load user profile
  Future<void> loadUserProfile(String userId) async {
    try {
      emit(ProfileState.loading());
      
      final profile = await _profileRepository.getUserProfile(userId);
      emit(ProfileState.loaded(profile));
    } catch (e) {
      final errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('Cubit: Error loading user profile', e);
      emit(ProfileState.error(errorMessage));
    }
  }
  
  // Create initial profile if none exists
  Future<void> createInitialProfile(String userId, String? fullName) async {
    try {
      emit(ProfileState.updating(state.userProfile));
      
      final profile = await _profileRepository.createUserProfile(
        userId: userId,
        fullName: fullName,
      );
      
      emit(ProfileState.loaded(profile));
    } catch (e) {
      final errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('Cubit: Error creating initial profile', e);
      emit(ProfileState.error(errorMessage));
    }
  }
  
  // Update user profile
  Future<bool> updateProfile({
    required String userId,
    String? fullName,
    int? age,
    double? height,
    double? weight,
    String? goal,
    String? fitnessLevel,
  }) async {
    try {
      emit(ProfileState.updating(state.userProfile));
      
      final updatedProfile = await _profileRepository.updateProfileFields(
        userId: userId,
        fullName: fullName,
        age: age,
        height: height,
        weight: weight,
        goal: goal,
        fitnessLevel: fitnessLevel,
      );
      
      if (updatedProfile != null) {
        emit(ProfileState.loaded(updatedProfile));
        return true;
      } else {
        emit(ProfileState.error('فشل تحديث الملف الشخصي. يرجى المحاولة مرة أخرى.'));
        return false;
      }
    } catch (e) {
      final errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('Cubit: Error updating profile', e);
      emit(ProfileState.error(errorMessage));
      return false;
    }
  }
  
  // Upload profile picture
  Future<bool> uploadProfilePicture(String userId, Uint8List imageBytes, String fileName) async {
    try {
      emit(ProfileState.updating(state.userProfile));
      
      final updatedProfile = await _profileRepository.uploadProfilePicture(
        userId,
        imageBytes,
        fileName,
      );
      
      if (updatedProfile != null) {
        emit(ProfileState.loaded(updatedProfile));
        return true;
      } else {
        emit(ProfileState.error('فشل تحديث صورة الملف الشخصي. يرجى المحاولة مرة أخرى.'));
        return false;
      }
    } catch (e) {
      final errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('Cubit: Error uploading profile picture', e);
      emit(ProfileState.error(errorMessage));
      return false;
    }
  }
  
  // Reset profile state
  void resetState() {
    emit(ProfileState.initial());
  }
} 