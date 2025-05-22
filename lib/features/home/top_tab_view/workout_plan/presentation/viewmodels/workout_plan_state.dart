part of 'workout_plan_cubit.dart';

abstract class WorkoutPlanState extends Equatable {
  const WorkoutPlanState();

  @override
  List<Object?> get props => [];
}

class WorkoutPlanInitial extends WorkoutPlanState {}

class WorkoutPlanLoading extends WorkoutPlanState {}

class WorkoutPlanError extends WorkoutPlanState {
  final String message;
  
  const WorkoutPlanError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// الخطة الرئيسية - عرض القائمة
class WorkoutPlansListLoaded extends WorkoutPlanState {
  final List<WorkoutPlanModel> plans;
  final bool hasMoreData;
  final int page;
  
  const WorkoutPlansListLoaded({
    required this.plans, 
    this.hasMoreData = false,
    this.page = 0,
  });
  
  @override
  List<Object?> get props => [plans, hasMoreData, page];
}

// تفاصيل خطة التمرين الواحدة
class WorkoutPlanDetailsLoaded extends WorkoutPlanState {
  final WorkoutPlanModel plan;
  final List<WorkoutWeekModel> weeks;
  final int selectedWeekIndex;
  
  const WorkoutPlanDetailsLoaded({
    required this.plan,
    required this.weeks,
    this.selectedWeekIndex = 0,
  });
  
  WorkoutWeekModel? get selectedWeek => 
      weeks.isNotEmpty && selectedWeekIndex < weeks.length 
          ? weeks[selectedWeekIndex] 
          : null;
  
  @override
  List<Object?> get props => [plan, weeks, selectedWeekIndex];
}

// أسبوع التمرين مع الأيام
class WorkoutWeekDaysLoaded extends WorkoutPlanState {
  final WorkoutWeekModel week;
  final List<WorkoutDayModel> days;
  final int selectedDayIndex;
  
  const WorkoutWeekDaysLoaded({
    required this.week,
    required this.days,
    this.selectedDayIndex = 0,
  });
  
  WorkoutDayModel? get selectedDay =>
      days.isNotEmpty && selectedDayIndex < days.length
          ? days[selectedDayIndex]
          : null;
  
  @override
  List<Object?> get props => [week, days, selectedDayIndex];
}

// تمارين اليوم
class WorkoutDayExercisesLoaded extends WorkoutPlanState {
  final WorkoutDayModel day;
  final List<DayExerciseModel> exercises;
  
  const WorkoutDayExercisesLoaded({
    required this.day,
    required this.exercises,
  });
  
  int get completedExercises => exercises.where((e) => e.isCompleted).length;
  double get progressPercentage => exercises.isEmpty ? 0.0 
      : (completedExercises / exercises.length) * 100;
  
  @override
  List<Object?> get props => [day, exercises];
} 