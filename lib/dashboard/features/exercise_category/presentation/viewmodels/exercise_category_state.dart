import 'package:equatable/equatable.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/models/exercise_category_model.dart';

abstract class ExerciseCategoryState extends Equatable {
  const ExerciseCategoryState();

  @override
  List<Object?> get props => [];
}

class ExerciseCategoryInitial extends ExerciseCategoryState {}

class ExerciseCategoryLoading extends ExerciseCategoryState {}

class ExerciseCategoryLoaded extends ExerciseCategoryState {
  final List<ExerciseCategory> categories;

  const ExerciseCategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ExerciseCategoryError extends ExerciseCategoryState {
  final String message;

  const ExerciseCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExerciseCategoryAdding extends ExerciseCategoryState {}

class ExerciseCategoryAdded extends ExerciseCategoryState {
  final ExerciseCategory category;

  const ExerciseCategoryAdded(this.category);

  @override
  List<Object?> get props => [category];
}

class ExerciseCategoryUpdating extends ExerciseCategoryState {}

class ExerciseCategoryUpdated extends ExerciseCategoryState {
  final ExerciseCategory category;

  const ExerciseCategoryUpdated(this.category);

  @override
  List<Object?> get props => [category];
}

class ExerciseCategoryDeleting extends ExerciseCategoryState {}

class ExerciseCategoryDeleted extends ExerciseCategoryState {
  final int categoryId;

  const ExerciseCategoryDeleted(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
} 