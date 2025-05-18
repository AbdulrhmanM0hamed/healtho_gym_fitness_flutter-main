import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/login/data/models/user_profile_model.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  updating,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfileModel? userProfile;
  final String errorMessage;
  
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userProfile,
    this.errorMessage = '',
  });
  
  bool get isLoading => status == ProfileStatus.loading || status == ProfileStatus.updating;
  bool get isLoaded => status == ProfileStatus.loaded;
  bool get hasError => status == ProfileStatus.error;
  
  // Initial state factory constructor
  factory ProfileState.initial() => const ProfileState(
    status: ProfileStatus.initial, 
    userProfile: null, 
    errorMessage: '',
  );
  
  // Loading state factory constructor
  factory ProfileState.loading() => const ProfileState(
    status: ProfileStatus.loading, 
    userProfile: null, 
    errorMessage: '',
  );
  
  // Loaded state factory constructor
  factory ProfileState.loaded(UserProfileModel? userProfile) => ProfileState(
    status: ProfileStatus.loaded, 
    userProfile: userProfile, 
    errorMessage: '',
  );
  
  // Updating state factory constructor
  factory ProfileState.updating(UserProfileModel? currentProfile) => ProfileState(
    status: ProfileStatus.updating, 
    userProfile: currentProfile, 
    errorMessage: '',
  );
  
  // Error state factory constructor
  factory ProfileState.error(String errorMessage) => ProfileState(
    status: ProfileStatus.error, 
    userProfile: null, 
    errorMessage: errorMessage,
  );
  
  // copyWith method for creating new instances
  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileModel? userProfile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  // Check if profile is complete
  bool get isProfileComplete {
    if (userProfile == null) return false;
    
    return userProfile!.fullName != null && 
           userProfile!.age != null && 
           userProfile!.height != null && 
           userProfile!.weight != null && 
           userProfile!.goal != null;
  }
  
  @override
  List<Object?> get props => [status, userProfile, errorMessage];
} 