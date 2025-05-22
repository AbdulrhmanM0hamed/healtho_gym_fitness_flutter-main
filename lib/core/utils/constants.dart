class Constants {
  // Supabase
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // API endpoints
  static const String workoutPlansEndpoint = 'workout_plans_with_favorite';
  static const String workoutWeeksEndpoint = 'workout_weeks';
  static const String workoutDaysEndpoint = 'workout_days';
  static const String dayExercisesEndpoint = 'day_exercises';
  static const String userWorkoutProgressEndpoint = 'user_workout_progress';
  static const String userExerciseCompletionEndpoint = 'user_exercise_completion';
  static const String userFavoritePlansEndpoint = 'user_favorite_plans';
  
  // Cache keys
  static const String workoutPlansCache = 'workout_plans_cache';
  static const String workoutWeeksCache = 'workout_weeks_cache';
  static const String workoutDaysCache = 'workout_days_cache';
  static const String dayExercisesCache = 'day_exercises_cache';
} 