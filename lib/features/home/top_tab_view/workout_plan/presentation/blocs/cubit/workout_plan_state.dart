part of 'workout_plan_cubit.dart';

sealed class WorkoutPlanState extends Equatable {
  const WorkoutPlanState();

  @override
  List<Object> get props => [];
}

final class WorkoutPlanInitial extends WorkoutPlanState {}
