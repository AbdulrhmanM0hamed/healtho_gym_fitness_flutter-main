import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/datasources/workout_plan_remote_data_source.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/workout_plan_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/workout_week_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/workout_day_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/day_exercise_model.dart';

class WorkoutPlanRepository {
  final WorkoutPlanRemoteDataSource _remoteDataSource;

  WorkoutPlanRepository(this._remoteDataSource);

  Future<List<WorkoutPlanModel>> getWorkoutPlans({
    int limit = 10,
    int offset = 0,
    String? goal,
    String? level,
    int? duration,
    int? categoryId,
    int? exerciseId,
  }) async {
    final plansJson = await _remoteDataSource.getWorkoutPlans(
      limit: limit,
      offset: offset,
      goal: goal,
      level: level,
      duration: duration,
      categoryId: categoryId,
      exerciseId: exerciseId,
    );
    
    return plansJson.map((json) => WorkoutPlanModel.fromJson(json)).toList();
  }

  Future<int> getWorkoutPlansCount() async {
    return await _remoteDataSource.getWorkoutPlansCount();
  }

  Future<WorkoutPlanModel> getWorkoutPlanDetails(int planId) async {
    final response = await _remoteDataSource.getWorkoutPlanDetails(planId);
    return WorkoutPlanModel.fromJson(response);
  }

  Future<List<WorkoutWeekModel>> getWorkoutWeeks(int planId) async {
    final response = await _remoteDataSource.getWorkoutWeeks(planId);
    return response.map((json) => WorkoutWeekModel.fromJson(json)).toList();
  }

  Future<List<WorkoutDayModel>> getWorkoutDays(int weekId) async {
    final response = await _remoteDataSource.getWorkoutDays(weekId);
    return response.map((json) => WorkoutDayModel.fromJson(json)).toList();
  }

  Future<List<DayExerciseModel>> getDayExercises(int dayId) async {
    final response = await _remoteDataSource.getDayExercises(dayId);
    return response.map((json) {
      // Extract exercise name and image from joined data
      final exerciseName = json['exercises']?['title'] ?? '';
      final exerciseImage = json['exercises']?['main_image_url'] ?? '';
      
      // Create a new JSON with the exercise data included
      final modifiedJson = {
        ...json,
        'exercise_name': exerciseName,
        'exercise_image': exerciseImage,
      };
      
      return DayExerciseModel.fromJson(modifiedJson);
    }).toList();
  }

  Future<bool> toggleExerciseCompletion(int dayExerciseId, bool isCompleted) async {
    return await _remoteDataSource.toggleExerciseCompletion(dayExerciseId, isCompleted);
  }

  Future<bool> togglePlanFavorite(int planId) async {
    return await _remoteDataSource.togglePlanFavorite(planId);
  }
} 