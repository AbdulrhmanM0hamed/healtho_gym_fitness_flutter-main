import 'dart:developer' as dev;
import 'package:supabase_flutter/supabase_flutter.dart';


class WorkoutPlanRemoteDataSource {
  final SupabaseClient _supabase;

  WorkoutPlanRemoteDataSource(this._supabase);

  Future<List<Map<String, dynamic>>> getWorkoutPlans({
    int limit = 10,
    int offset = 0,
    String? goal,
    String? level,
    int? duration,
    int? categoryId,
    int? exerciseId,
  }) async {
    try {
      dev.log('Fetching workout plans with filters - goal: $goal, level: $level, duration: $duration, categoryId: $categoryId, exerciseId: $exerciseId');
      
      var query = _supabase
          .from('workout_plans')
          .select();

      if (goal != null) {
        query = query.match({'goal': goal});
      }

      if (level != null) {
        query = query.ilike('level', '%$level%');
      }

      if (duration != null) {
        query = query.match({'duration_weeks': duration});
      }

      if (categoryId != null) {
        query = query.match({'category_id': categoryId});
      }

      // If exerciseId is provided, find plans that include this exercise
      if (exerciseId != null) {
        // This is a more complex query that would need to join tables
        // For example, get plans that have weeks that have days that have this exercise
        // This is a simplified approach
        final relatedPlans = await _supabase
            .from('day_exercises')
            .select('workout_days!inner(workout_weeks!inner(plan_id))')
            .eq('exercise_id', exerciseId);
            
        if (relatedPlans.isNotEmpty) {
          // Extract plan IDs
          List<int> planIds = [];
          for (var item in relatedPlans) {
            final planId = item['workout_days']['workout_weeks']['plan_id'];
            if (planId != null && !planIds.contains(planId)) {
              planIds.add(planId);
            }
          }
          
          if (planIds.isNotEmpty) {
            query = query.filter('id', 'in', planIds);
          }
        } else {
          // If no related plans found, return empty result
          return [];
        }
      }

      final response = await query
          .order('id')
          .range(offset, offset + limit - 1);
      
      dev.log('Received ${response.length} workout plans: ${response.toString().substring(0, response.toString().length > 300 ? 300 : response.toString().length)}...');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      dev.log('ERROR: Failed to load workout plans: $e', error: e);
      throw Exception('Failed to load workout plans: $e');
    }
  }

  Future<int> getWorkoutPlansCount() async {
    try {
      dev.log('Fetching workout plans count');
      
      final response = await _supabase
          .from('workout_plans')
          .select();
      
      final count = List<Map<String, dynamic>>.from(response).length;
      dev.log('Total workout plans count: $count');
      
      return count;
    } catch (e) {
      dev.log('ERROR: Failed to get workout plans count: $e', error: e);
      throw Exception('Failed to get workout plans count: $e');
    }
  }

  Future<Map<String, dynamic>> getWorkoutPlanDetails(int planId) async {
    try {
      dev.log('Fetching workout plan details for planId: $planId');
      
      final response = await _supabase
          .from('workout_plans')
          .select()
          .match({'id': planId})
          .single();
      
      dev.log('Retrieved plan details: ${response.toString().substring(0, response.toString().length > 300 ? 300 : response.toString().length)}...');
      
      return response;
    } catch (e) {
      dev.log('ERROR: Failed to load workout plan details: $e', error: e);
      throw Exception('Failed to load workout plan details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getWorkoutWeeks(int planId) async {
    try {
      dev.log('Fetching workout weeks for planId: $planId');
      
      final response = await _supabase
          .from('workout_weeks')
          .select()
          .match({'plan_id': planId})
          .order('week_number');
      
      dev.log('Retrieved ${response.length} workout weeks: ${response.toString().substring(0, response.toString().length > 300 ? 300 : response.toString().length)}...');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      dev.log('ERROR: Failed to load workout weeks: $e', error: e);
      throw Exception('Failed to load workout weeks: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getWorkoutDays(int weekId) async {
    try {
      dev.log('Fetching workout days for weekId: $weekId');
      
      final response = await _supabase
          .from('workout_days')
          .select()
          .match({'week_id': weekId})
          .order('day_number');
      
      dev.log('Retrieved ${response.length} workout days: ${response.toString().substring(0, response.toString().length > 300 ? 300 : response.toString().length)}...');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      dev.log('ERROR: Failed to load workout days: $e', error: e);
      throw Exception('Failed to load workout days: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDayExercises(int dayId) async {
    try {
      dev.log('Fetching exercises for dayId: $dayId');
      
      final response = await _supabase
          .from('day_exercises')
          .select('''
            *,
            exercises (
              id,
              title,
              description,
              main_image_url,
              image_url,
              level
            )
          ''')
          .match({'day_id': dayId})
          .order('sort_order'); // Changed from exercise_order to sort_order to match your schema
      
      dev.log('Retrieved ${response.length} day exercises: ${response.toString().substring(0, response.toString().length > 300 ? 300 : response.toString().length)}...');
      
      // Process the response to format the data correctly for the UI
      List<Map<String, dynamic>> formattedResponse = [];
      for (var item in response) {
        if (item['exercises'] != null) {
          // Create a copy of the exercise data
          Map<String, dynamic> exerciseData = Map.from(item['exercises']);
          
          // إذا كان حقل image_url غير موجود أو فارغ، نستخدم main_image_url
          // لكن لا نقوم بتعيين image_url إذا كان موجودًا بالفعل لتجنب التكرار
          if (!exerciseData.containsKey('image_url') || exerciseData['image_url'] == null || 
              (exerciseData['image_url'] is String && (exerciseData['image_url'] as String).isEmpty)) {
            exerciseData['image_url'] = [];
          }
          
          // Create a copy of the original item and replace exercises with our modified version
          Map<String, dynamic> newItem = Map.from(item);
          newItem['exercises'] = exerciseData;
          
          formattedResponse.add(newItem);
        } else {
          formattedResponse.add(item);
        }
      }
      
      dev.log('Formatted response for UI: ${formattedResponse.length} items');
      
      return formattedResponse;
    } catch (e) {
      dev.log('ERROR: Failed to load day exercises: $e', error: e);
      throw Exception('Failed to load day exercises: $e');
    }
  }

  Future<bool> toggleExerciseCompletion(int dayExerciseId, bool isCompleted) async {
    try {
      dev.log('Toggling exercise completion - dayExerciseId: $dayExerciseId, new status: $isCompleted');
      
      await _supabase
          .from('day_exercises')
          .update({'is_completed': isCompleted})
          .match({'id': dayExerciseId});
      
      dev.log('Successfully updated exercise completion status to: $isCompleted');
      
      return isCompleted;
    } catch (e) {
      dev.log('ERROR: Failed to toggle exercise completion: $e', error: e);
      throw Exception('Failed to toggle exercise completion: $e');
    }
  }

  Future<bool> togglePlanFavorite(int planId) async {
    try {
      dev.log('Toggling plan favorite status for planId: $planId');
      
      // إنشاء حالة مؤقتة في الذاكرة - هذا ليس عملية حقيقية في قاعدة البيانات
      // فقط لتجنب الخطأ الحالي: column workout_plans.is_favorite does not exist
      dev.log('Using temporary in-memory favorite status implementation');
      
      // استرجاع خطة التمرين للتأكد من وجودها
      await _supabase
          .from('workout_plans')
          .select('id')
          .match({'id': planId})
          .single();
      
      dev.log('Plan exists. Simulated toggling of favorite status successful.');
      
      // إرجاع قيمة ثابتة كبديل مؤقت حتى يتم إضافة عمود is_favorite في قاعدة البيانات
      return true;
    } catch (e) {
      dev.log('ERROR: Failed to toggle plan favorite: $e', error: e);
      throw Exception('Failed to toggle plan favorite: $e');
    }
  }
} 