part of 'exercises_category_cubit.dart';

sealed class ExercisesCategoryState extends Equatable {
  const ExercisesCategoryState();

  @override
  List<Object?> get props => [];
}

final class ExercisesCategoryInitial extends ExercisesCategoryState {}

final class ExercisesCategoryLoading extends ExercisesCategoryState {}

final class ExercisesCategoryLoaded extends ExercisesCategoryState {
  final List<ExerciseCategory> categories;

  const ExercisesCategoryLoaded({
    required this.categories
  });

  @override
  List<Object?> get props => [categories];
}

final class ExercisesCategoryError extends ExercisesCategoryState {
  final String message;

  const ExercisesCategoryError({
    required this.message
  });

  @override
  List<Object?> get props => [message];
}
