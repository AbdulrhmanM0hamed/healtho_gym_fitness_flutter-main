import 'dart:developer' as dev;
      import 'package:supabase_flutter/supabase_flutter.dart';
      import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_plan_model.dart';
      import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_week_model.dart';
      import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_day_model.dart';
      import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_day_exercise_model.dart';
      import 'package:healtho_gym/dashboard/features/workout_plan/data/repositories/dashboard_workout_plan_repository.dart';
      
      /// تنفيذ مستودع خطط التمرين في لوحة التحكم باستخدام Supabase
      class DashboardWorkoutPlanRepositoryImpl implements DashboardWorkoutPlanRepository {
        final SupabaseClient _supabase;
        
        DashboardWorkoutPlanRepositoryImpl({SupabaseClient? supabase}) 
            : _supabase = supabase ?? Supabase.instance.client;
      
        @override
        Future<List<DashboardWorkoutPlanModel>> getAllWorkoutPlans() async {
          try {
            dev.log('Fetching all workout plans');
            
            final response = await _supabase
                .from('workout_plans')
                .select('*')
                .order('created_at', ascending: false);
            
            dev.log('Retrieved ${response.length} workout plans');
            
            return response.map<DashboardWorkoutPlanModel>((json) => 
                DashboardWorkoutPlanModel.fromJson(json)).toList();
          } catch (e) {
            dev.log('ERROR: Failed to load workout plans: $e', error: e);
            throw Exception('فشل في الحصول على خطط التمرين: $e');
          }
        }
      
        @override
        Future<DashboardWorkoutPlanModel> getWorkoutPlanById(int planId) async {
          try {
            dev.log('Fetching workout plan with ID: $planId');
            
            final response = await _supabase
                .from('workout_plans')
                .select('*')
                .eq('id', planId)
                .single();
            
            dev.log('Retrieved workout plan with ID: $planId');
            
            return DashboardWorkoutPlanModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to load workout plan: $e', error: e);
            throw Exception('فشل في الحصول على خطة التمرين: $e');
          }
        }
      
        @override
        Future<DashboardWorkoutPlanModel> addWorkoutPlan(DashboardWorkoutPlanModel plan) async {
          try {
            dev.log('Adding new workout plan: ${plan.title}');
            
            final response = await _supabase
                .from('workout_plans')
                .insert(plan.toJson())
                .select()
                .single();
            
            dev.log('Successfully added workout plan with ID: ${response['id']}');
            
            return DashboardWorkoutPlanModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to add workout plan: $e', error: e);
            throw Exception('فشل في إضافة خطة التمرين: $e');
          }
        }
      
        @override
        Future<DashboardWorkoutPlanModel> updateWorkoutPlan(DashboardWorkoutPlanModel plan) async {
          try {
            dev.log('Updating workout plan with ID: ${plan.id}');
            
            final response = await _supabase
                .from('workout_plans')
                .update(plan.toJson())
                .eq('id', plan.id ?? 0)
                .select()
                .single();
            
            dev.log('Successfully updated workout plan with ID: ${plan.id}');
            
            return DashboardWorkoutPlanModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to update workout plan: $e', error: e);
            throw Exception('فشل في تحديث خطة التمرين: $e');
          }
        }
      
        @override
        Future<bool> deleteWorkoutPlan(int planId) async {
          try {
            dev.log('Deleting workout plan with ID: $planId');
            
            await _supabase
                .from('workout_plans')
                .delete()
                .eq('id', planId);
            
            dev.log('Successfully deleted workout plan with ID: $planId');
            
            return true;
          } catch (e) {
            dev.log('ERROR: Failed to delete workout plan: $e', error: e);
            throw Exception('فشل في حذف خطة التمرين: $e');
          }
        }
      
        @override
        Future<List<DashboardWorkoutWeekModel>> getWeeksForPlan(int planId) async {
          try {
            dev.log('Fetching weeks for plan ID: $planId');
            
            final response = await _supabase
                .from('workout_weeks')
                .select('*')
                .eq('plan_id', planId)
                .order('week_number');
            
            dev.log('Retrieved ${response.length} weeks for plan ID: $planId');
            
            return response.map<DashboardWorkoutWeekModel>((json) => 
                DashboardWorkoutWeekModel.fromJson(json)).toList();
          } catch (e) {
            dev.log('ERROR: Failed to load weeks for plan: $e', error: e);
            throw Exception('فشل في الحصول على أسابيع الخطة: $e');
          }
        }
      
        @override
        Future<DashboardWorkoutWeekModel> addWeekToPlan(DashboardWorkoutWeekModel week) async {
          try {
            dev.log('Adding new week to plan ID: ${week.planId}');
            
            final response = await _supabase
                .from('workout_weeks')
                .insert(week.toJson())
                .select()
                .single();
            
            dev.log('Successfully added week with ID: ${response['id']}');
            
            return DashboardWorkoutWeekModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to add week to plan: $e', error: e);
            throw Exception('فشل في إضافة أسبوع للخطة: $e');
          }
        }
      
        @override
        Future<DashboardWorkoutWeekModel> updateWeek(DashboardWorkoutWeekModel week) async {
          try {
            dev.log('Updating week with ID: ${week.id}');
            
            final response = await _supabase
                .from('workout_weeks')
                .update(week.toJson())
                .eq('id', week.id ?? 0)
                .select()
                .single();
            
            dev.log('Successfully updated week with ID: ${week.id}');
            
            return DashboardWorkoutWeekModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to update week: $e', error: e);
            throw Exception('فشل في تحديث الأسبوع: $e');
          }
        }
      
        @override
        Future<bool> deleteWeek(int weekId) async {
          try {
            dev.log('Deleting week with ID: $weekId');
            
            await _supabase
                .from('workout_weeks')
                .delete()
                .eq('id', weekId);
            
            dev.log('Successfully deleted week with ID: $weekId');
            
            return true;
          } catch (e) {
            dev.log('ERROR: Failed to delete week: $e', error: e);
            throw Exception('فشل في حذف الأسبوع: $e');
          }
        }
      
        @override
        Future<List<DashboardWorkoutDayModel>> getDaysForWeek(int weekId) async {
          try {
            dev.log('Fetching days for week ID: $weekId');
            
            final response = await _supabase
                .from('workout_days')
                .select('*')
                .eq('week_id', weekId)
                .order('day_number');
            
            dev.log('Retrieved ${response.length} days for week ID: $weekId');
            
            return response.map<DashboardWorkoutDayModel>((json) => 
                DashboardWorkoutDayModel.fromJson(json)).toList();
          } catch (e) {
            dev.log('ERROR: Failed to load days for week: $e', error: e);
            throw Exception('فشل في الحصول على أيام الأسبوع: $e');
          }
        }
      
        @override
        Future<DashboardWorkoutDayModel> addDayToWeek(DashboardWorkoutDayModel day) async {
          try {
            dev.log('Adding new day to week ID: ${day.weekId}');
            
            final response = await _supabase
                .from('workout_days')
                .insert(day.toJson())
                .select()
                .single();
            
            dev.log('Successfully added day with ID: ${response['id']}');
            
            return DashboardWorkoutDayModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to add day to week: $e', error: e);
            throw Exception('فشل في إضافة يوم للأسبوع: $e');
          }
        }
      
        @override
        Future<DashboardWorkoutDayModel> updateDay(DashboardWorkoutDayModel day) async {
          try {
            dev.log('Updating day with ID: ${day.id}');
            
            final response = await _supabase
                .from('workout_days')
                .update(day.toJson())
                .eq('id', day.id ?? 0)
                .select()
                .single();
            
            dev.log('Successfully updated day with ID: ${day.id}');
            
            return DashboardWorkoutDayModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to update day: $e', error: e);
            throw Exception('فشل في تحديث اليوم: $e');
          }
        }
      
        @override
        Future<bool> deleteDay(int dayId) async {
          try {
            dev.log('Deleting day with ID: $dayId');
            
            await _supabase
                .from('workout_days')
                .delete()
                .eq('id', dayId);
            
            dev.log('Successfully deleted day with ID: $dayId');
            
            return true;
          } catch (e) {
            dev.log('ERROR: Failed to delete day: $e', error: e);
            throw Exception('فشل في حذف اليوم: $e');
          }
        }
      
        @override
        Future<List<DashboardDayExerciseModel>> getExercisesForDay(int dayId) async {
          try {
            dev.log('Fetching exercises for day ID: $dayId');
            
            final response = await _supabase
                .from('day_exercises')
                .select('''
                  *,
                  exercises (
                    id,
                    title,
                    description,
                    main_image_url,
                    level
                  )
                ''')
                .eq('day_id', dayId)
                .order('sort_order');
            
            dev.log('Retrieved ${response.length} exercises for day ID: $dayId');
            
            return response.map<DashboardDayExerciseModel>((json) => 
                DashboardDayExerciseModel.fromJson(json)).toList();
          } catch (e) {
            dev.log('ERROR: Failed to load exercises for day: $e', error: e);
            throw Exception('فشل في الحصول على تمارين اليوم: $e');
          }
        }
      
        @override
        Future<DashboardDayExerciseModel> addExerciseToDay(DashboardDayExerciseModel exercise) async {
          try {
            dev.log('Adding new exercise to day ID: ${exercise.dayId}');
            
            final response = await _supabase
                .from('day_exercises')
                .insert(exercise.toJson())
                .select()
                .single();
            
            dev.log('Successfully added exercise with ID: ${response['id']}');
            
            return DashboardDayExerciseModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to add exercise to day: $e', error: e);
            throw Exception('فشل في إضافة تمرين لليوم: $e');
          }
        }
      
        @override
        Future<DashboardDayExerciseModel> updateExercise(DashboardDayExerciseModel exercise) async {
          try {
            dev.log('Updating exercise with ID: ${exercise.id}');
            
            final response = await _supabase
                .from('day_exercises')
                .update(exercise.toJson())
                .eq('id', exercise.id ?? 0)
                .select()
                .single();
            
            dev.log('Successfully updated exercise with ID: ${exercise.id}');
            
            return DashboardDayExerciseModel.fromJson(response);
          } catch (e) {
            dev.log('ERROR: Failed to update exercise: $e', error: e);
            throw Exception('فشل في تحديث التمرين: $e');
          }
        }
      
        @override
        Future<bool> deleteExercise(int exerciseId) async {
          try {
            dev.log('Deleting exercise with ID: $exerciseId');
            
            await _supabase
                .from('day_exercises')
                .delete()
                .eq('id', exerciseId);
            
            dev.log('Successfully deleted exercise with ID: $exerciseId');
            
            return true;
          } catch (e) {
            dev.log('ERROR: Failed to delete exercise: $e', error: e);
            throw Exception('فشل في حذف التمرين: $e');
          }
        }
      }
    