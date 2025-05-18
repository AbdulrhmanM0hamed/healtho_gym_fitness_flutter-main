class DBConstants {
  // Table names
  static const String usersTable = 'users';
  static const String userProfilesTable = 'user_profiles';
  static const String workoutPlansTable = 'workout_plans';
  static const String exercisesTable = 'exercises';
  
  // Users table fields
  static const String userId = 'id';
  static const String email = 'email';
  static const String createdAt = 'created_at';
  
  // User profiles table fields
  static const String profileId = 'id';
  static const String profileUserId = 'user_id';
  static const String fullName = 'full_name';
  static const String age = 'age';
  static const String height = 'height';
  static const String weight = 'weight';
  static const String goal = 'goal';
  static const String fitnessLevel = 'fitness_level';
  static const String profilePictureUrl = 'profile_picture_url';
  static const String updateDate = 'update_date';
  static const String isAdmin = 'is_admin';
  
  // Workout plans table fields
  static const String planId = 'id';
  static const String planUserId = 'user_id';
  static const String planName = 'name';
  static const String planDescription = 'description';
  static const String planDuration = 'duration_weeks';
  static const String planDifficulty = 'difficulty';
  static const String planCreatedAt = 'created_at';
  
  // Exercises table fields
  static const String exerciseId = 'id';
  static const String exerciseName = 'name';
  static const String exerciseDescription = 'description';
  static const String exerciseCategory = 'category';
  static const String exerciseMuscleGroup = 'muscle_group';
  static const String exerciseImageUrl = 'image_url';
  static const String exerciseVideoUrl = 'video_url';
} 