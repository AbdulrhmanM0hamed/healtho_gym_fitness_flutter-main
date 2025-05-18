import 'package:healtho_gym/features/login/data/models/user_profile_model.dart';

class UserWithProfile {
  final String id;
  final String? email;
  final DateTime? createdAt;
  final UserProfileModel? profile;

  UserWithProfile({
    required this.id,
    this.email,
    this.createdAt,
    this.profile,
  });

  factory UserWithProfile.fromJson(Map<String, dynamic> json) {
    return UserWithProfile(
      id: json['id'],
      email: json['email'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      profile: json['profile'] != null ? UserProfileModel.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'profile': profile?.toJson(),
    };
  }

  UserWithProfile copyWith({
    String? id,
    String? email,
    DateTime? createdAt,
    UserProfileModel? profile,
  }) {
    return UserWithProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      profile: profile ?? this.profile,
    );
  }
} 