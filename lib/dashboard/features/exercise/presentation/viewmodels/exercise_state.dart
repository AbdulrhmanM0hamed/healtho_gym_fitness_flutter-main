import 'package:equatable/equatable.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/models/exercise_model.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final int categoryId;
  final int selectedLevel;

  const ExerciseLoaded({
    required this.exercises,
    required this.categoryId,
    required this.selectedLevel,
  });

  @override
  List<Object?> get props => [exercises, categoryId, selectedLevel];
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExerciseAdding extends ExerciseState {}

class ExerciseAdded extends ExerciseState {
  final Exercise exercise;

  const ExerciseAdded(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class ExerciseUpdating extends ExerciseState {}

class ExerciseUpdated extends ExerciseState {
  final Exercise exercise;

  const ExerciseUpdated(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class ExerciseDeleting extends ExerciseState {}

class ExerciseDeleted extends ExerciseState {
  final int exerciseId;

  const ExerciseDeleted(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

class ExerciseTogglingFavorite extends ExerciseState {}

class ExerciseToggledFavorite extends ExerciseState {
  final int exerciseId;
  final bool isFavorite;

  const ExerciseToggledFavorite(this.exerciseId, this.isFavorite);

  @override
  List<Object?> get props => [exerciseId, isFavorite];
} 