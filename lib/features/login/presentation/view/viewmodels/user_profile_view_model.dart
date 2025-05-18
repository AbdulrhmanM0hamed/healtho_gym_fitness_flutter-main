import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/login/data/models/user_profile_model.dart';
import 'package:healtho_gym/features/login/data/repositories/user_profile_repository.dart';
import 'package:healtho_gym/core/utils/error_util.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  updating,
  error,
}

class UserProfileViewModel extends ChangeNotifier {
  final UserProfileRepository _profileRepository = sl<UserProfileRepository>();
  
  ProfileStatus _status = ProfileStatus.initial;
  UserProfileModel? _userProfile;
  String _errorMessage = '';
  dynamic _rawError;
  
  // Getters
  ProfileStatus get status => _status;
  UserProfileModel? get userProfile => _userProfile;
  String get errorMessage => _errorMessage;
  dynamic get rawError => _rawError;
  
  // Load user profile
  Future<void> loadUserProfile(String userId) async {
    try {
      _status = ProfileStatus.loading;
      _errorMessage = '';
      _rawError = null;
      notifyListeners();
      
      final profile = await _profileRepository.getUserProfile(userId);
      _userProfile = profile;
      _status = ProfileStatus.loaded;
      
      notifyListeners();
    } catch (e) {
      _status = ProfileStatus.error;
      _rawError = e;
      _errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('ViewModel: Error loading user profile', e);
      notifyListeners();
    }
  }
  
  // Create initial profile if none exists
  Future<void> createInitialProfile(String userId, String? fullName) async {
    try {
      _status = ProfileStatus.updating;
      _errorMessage = '';
      _rawError = null;
      notifyListeners();
      
      final profile = await _profileRepository.createUserProfile(
        userId: userId,
        fullName: fullName,
      );
      
      _userProfile = profile;
      _status = ProfileStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = ProfileStatus.error;
      _rawError = e;
      _errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('ViewModel: Error creating initial profile', e);
      notifyListeners();
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
      _status = ProfileStatus.updating;
      _errorMessage = '';
      _rawError = null;
      notifyListeners();
      
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
        _userProfile = updatedProfile;
        _status = ProfileStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ProfileStatus.error;
        _errorMessage = 'فشل تحديث الملف الشخصي. يرجى المحاولة مرة أخرى.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ProfileStatus.error;
      _rawError = e;
      _errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('ViewModel: Error updating profile', e);
      notifyListeners();
      return false;
    }
  }
  
  // Upload profile picture
  Future<bool> uploadProfilePicture(String userId, Uint8List imageBytes, String fileName) async {
    try {
      _status = ProfileStatus.updating;
      _errorMessage = '';
      _rawError = null;
      notifyListeners();
      
      final updatedProfile = await _profileRepository.uploadProfilePicture(
        userId,
        imageBytes,
        fileName,
      );
      
      if (updatedProfile != null) {
        _userProfile = updatedProfile;
        _status = ProfileStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ProfileStatus.error;
        _errorMessage = 'فشل تحديث صورة الملف الشخصي. يرجى المحاولة مرة أخرى.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ProfileStatus.error;
      _rawError = e;
      _errorMessage = ErrorUtil.getProfileErrorMessage(e);
      LoggerUtil.error('ViewModel: Error uploading profile picture', e);
      notifyListeners();
      return false;
    }
  }
  
  // Check if profile needs to be completed
  bool get isProfileComplete {
    if (_userProfile == null) return false;
    
    return _userProfile!.fullName != null && 
           _userProfile!.age != null && 
           _userProfile!.height != null && 
           _userProfile!.weight != null && 
           _userProfile!.goal != null;
  }
  
  // Reset profile state
  void resetState() {
    _status = ProfileStatus.initial;
    _userProfile = null;
    _errorMessage = '';
    _rawError = null;
    notifyListeners();
  }
} 