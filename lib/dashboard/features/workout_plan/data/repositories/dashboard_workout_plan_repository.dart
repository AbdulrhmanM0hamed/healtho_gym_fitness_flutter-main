import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_plan_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_week_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_day_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_day_exercise_model.dart';

/// واجهة مستودع خطط التمرين في لوحة التحكم
abstract class DashboardWorkoutPlanRepository {
  /// الحصول على جميع خطط التمرين
  Future<List<DashboardWorkoutPlanModel>> getAllWorkoutPlans();
  
  /// الحصول على خطة تمرين محددة
  Future<DashboardWorkoutPlanModel> getWorkoutPlanById(int planId);
  
  /// إضافة خطة تمرين جديدة
  Future<DashboardWorkoutPlanModel> addWorkoutPlan(DashboardWorkoutPlanModel plan);
  
  /// تحديث خطة تمرين موجودة
  Future<DashboardWorkoutPlanModel> updateWorkoutPlan(DashboardWorkoutPlanModel plan);
  
  /// حذف خطة تمرين
  Future<bool> deleteWorkoutPlan(int planId);
  
  /// الحصول على أسابيع خطة تمرين محددة
  Future<List<DashboardWorkoutWeekModel>> getWeeksForPlan(int planId);
  
  /// إضافة أسبوع جديد لخطة تمرين
  Future<DashboardWorkoutWeekModel> addWeekToPlan(DashboardWorkoutWeekModel week);
  
  /// تحديث أسبوع موجود
  Future<DashboardWorkoutWeekModel> updateWeek(DashboardWorkoutWeekModel week);
  
  /// حذف أسبوع
  Future<bool> deleteWeek(int weekId);
  
  /// الحصول على أيام أسبوع محدد
  Future<List<DashboardWorkoutDayModel>> getDaysForWeek(int weekId);
  
  /// إضافة يوم جديد لأسبوع
  Future<DashboardWorkoutDayModel> addDayToWeek(DashboardWorkoutDayModel day);
  
  /// تحديث يوم موجود
  Future<DashboardWorkoutDayModel> updateDay(DashboardWorkoutDayModel day);
  
  /// حذف يوم
  Future<bool> deleteDay(int dayId);
  
  /// الحصول على تمارين يوم محدد
  Future<List<DashboardDayExerciseModel>> getExercisesForDay(int dayId);
  
  /// إضافة تمرين جديد ليوم
  Future<DashboardDayExerciseModel> addExerciseToDay(DashboardDayExerciseModel exercise);
  
  /// تحديث تمرين موجود
  Future<DashboardDayExerciseModel> updateExercise(DashboardDayExerciseModel exercise);
  
  /// حذف تمرين
  Future<bool> deleteExercise(int exerciseId);
}
