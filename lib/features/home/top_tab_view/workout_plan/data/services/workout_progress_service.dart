import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/services/exercise_progress_service.dart';

/// خدمة لحساب تقدم خطط التمرين بناءً على التمارين المكتملة
class WorkoutProgressService {
  /// حساب نسبة إكمال الأسبوع بناءً على التمارين المكتملة
  static Future<double> calculateWeekCompletionPercentage(List<int> exerciseIds) async {
    if (exerciseIds.isEmpty) return 0.0;
    
    final completedExercises = await ExerciseProgressService.getCompletedExercises();
    int completedCount = 0;
    
    for (final exerciseId in exerciseIds) {
      if (completedExercises.contains(exerciseId)) {
        completedCount++;
      }
    }
    
    return completedCount / exerciseIds.length;
  }
  
  /// حساب نسبة إكمال الخطة بناءً على التمارين المكتملة
  static Future<double> calculatePlanCompletionPercentage(Map<int, List<int>> weekExercises) async {
    if (weekExercises.isEmpty) return 0.0;
    
    final completedExercises = await ExerciseProgressService.getCompletedExercises();
    int totalExercises = 0;
    int completedCount = 0;
    
    weekExercises.forEach((weekId, exerciseIds) {
      totalExercises += exerciseIds.length;
      
      for (final exerciseId in exerciseIds) {
        if (completedExercises.contains(exerciseId)) {
          completedCount++;
        }
      }
    });
    
    return totalExercises > 0 ? completedCount / totalExercises : 0.0;
  }
  
  /// الحصول على عدد التمارين المكتملة في الخطة
  static Future<int> getCompletedExercisesCount(Map<int, List<int>> weekExercises) async {
    final completedExercises = await ExerciseProgressService.getCompletedExercises();
    int completedCount = 0;
    
    weekExercises.forEach((weekId, exerciseIds) {
      for (final exerciseId in exerciseIds) {
        if (completedExercises.contains(exerciseId)) {
          completedCount++;
        }
      }
    });
    
    return completedCount;
  }
  
  /// الحصول على إجمالي عدد التمارين في الخطة
  static int getTotalExercisesCount(Map<int, List<int>> weekExercises) {
    int totalExercises = 0;
    
    weekExercises.forEach((weekId, exerciseIds) {
      totalExercises += exerciseIds.length;
    });
    
    return totalExercises;
  }
}
