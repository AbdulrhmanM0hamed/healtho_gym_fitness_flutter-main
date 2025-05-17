class UserProfileModel {
  final String id;
  final String userId;
  final String? fullName;
  final int? age;
  final double? height; // in cm
  final double? weight; // in kg
  final String? goal;
  final String? fitnessLevel;
  final String? profilePictureUrl;
  final DateTime? updateDate;
  
  UserProfileModel({
    required this.id,
    required this.userId,
    this.fullName,
    this.age,
    this.height,
    this.weight,
    this.goal,
    this.fitnessLevel,
    this.profilePictureUrl,
    this.updateDate,
  });
  
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      userId: json['user_id'],
      fullName: json['full_name'],
      age: json['age'],
      height: json['height'] != null ? json['height'].toDouble() : null,
      weight: json['weight'] != null ? json['weight'].toDouble() : null,
      goal: json['goal'],
      fitnessLevel: json['fitness_level'],
      profilePictureUrl: json['profile_picture_url'],
      updateDate: json['update_date'] != null ? DateTime.parse(json['update_date']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'age': age,
      'height': height,
      'weight': weight,
      'goal': goal,
      'fitness_level': fitnessLevel,
      'profile_picture_url': profilePictureUrl,
      'update_date': updateDate?.toIso8601String(),
    };
  }
  
  UserProfileModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    int? age,
    double? height,
    double? weight,
    String? goal,
    String? fitnessLevel,
    String? profilePictureUrl,
    DateTime? updateDate,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      goal: goal ?? this.goal,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      updateDate: updateDate ?? this.updateDate,
    );
  }
} 