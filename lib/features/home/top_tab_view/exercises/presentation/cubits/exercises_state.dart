part of 'exercises_cubit.dart';

sealed class ExercisesState extends Equatable {
  const ExercisesState();

  @override
  List<Object?> get props => [];
}

final class ExercisesInitial extends ExercisesState {}

final class ExercisesLoading extends ExercisesState {}

final class ExercisesLoaded extends ExercisesState {
  final List<Exercise> exercises;
  final ExerciseCategory? category;
  final int selectedLevel;

  const ExercisesLoaded({
    required this.exercises, 
    this.category,
    this.selectedLevel = 1,
  });

  @override
  List<Object?> get props => [exercises, category, selectedLevel];
}

final class ExercisesError extends ExercisesState {
  final String message;

  const ExercisesError({
    required this.message
  });

  @override
  List<Object?> get props => [message];
} 