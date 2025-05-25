import 'package:equatable/equatable.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_plan_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_week_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_day_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_day_exercise_model.dart';

/// حالات كيوبت خطط التمرين في لوحة التحكم
abstract class DashboardWorkoutPlanState extends Equatable {
  const DashboardWorkoutPlanState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class DashboardWorkoutPlanInitial extends DashboardWorkoutPlanState {}

/// حالة جاري التحميل
class DashboardWorkoutPlanLoading extends DashboardWorkoutPlanState {}

/// حالة حدوث خطأ
class DashboardWorkoutPlanError extends DashboardWorkoutPlanState {
  final String message;

  const DashboardWorkoutPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة تحميل قائمة خطط التمرين بنجاح
class DashboardWorkoutPlansLoaded extends DashboardWorkoutPlanState {
  final List<DashboardWorkoutPlanModel> plans;

  const DashboardWorkoutPlansLoaded(this.plans);

  @override
  List<Object?> get props => [plans];
}

/// حالة تحميل خطة تمرين واحدة بنجاح
class DashboardWorkoutPlanLoaded extends DashboardWorkoutPlanState {
  final DashboardWorkoutPlanModel plan;

  const DashboardWorkoutPlanLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}

/// حالة تحميل أسابيع خطة تمرين بنجاح
class DashboardWorkoutWeeksLoaded extends DashboardWorkoutPlanState {
  final int planId;
  final List<DashboardWorkoutWeekModel> weeks;

  const DashboardWorkoutWeeksLoaded({
    required this.planId,
    required this.weeks,
  });

  @override
  List<Object?> get props => [planId, weeks];
}

/// حالة تحميل أيام أسبوع بنجاح
class DashboardWorkoutDaysLoaded extends DashboardWorkoutPlanState {
  final int weekId;
  final List<DashboardWorkoutDayModel> days;

  const DashboardWorkoutDaysLoaded({
    required this.weekId,
    required this.days,
  });

  @override
  List<Object?> get props => [weekId, days];
}

/// حالة تحميل تمارين يوم بنجاح
class DashboardDayExercisesLoaded extends DashboardWorkoutPlanState {
  final int dayId;
  final List<DashboardDayExerciseModel> exercises;

  const DashboardDayExercisesLoaded({
    required this.dayId,
    required this.exercises,
  });

  @override
  List<Object?> get props => [dayId, exercises];
}

/// حالة إضافة/تحديث/حذف عنصر بنجاح
class DashboardWorkoutPlanActionSuccess extends DashboardWorkoutPlanState {
  final String message;
  final String actionType; // 'add', 'update', 'delete'
  final String entityType; // 'plan', 'week', 'day', 'exercise'

  const DashboardWorkoutPlanActionSuccess({
    required this.message,
    required this.actionType,
    required this.entityType,
  });

  @override
  List<Object?> get props => [message, actionType, entityType];
}
