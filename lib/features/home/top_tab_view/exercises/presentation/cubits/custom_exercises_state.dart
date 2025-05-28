import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/custom_exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';

/// حالات التمارين المخصصة
abstract class CustomExercisesState extends Equatable {
  const CustomExercisesState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class CustomExercisesInitial extends CustomExercisesState {}

/// حالة التحميل
class CustomExercisesLoading extends CustomExercisesState {}

/// حالة تم تحميل التمارين المخصصة
class CustomExercisesLoaded extends CustomExercisesState {
  final List<CustomExercise> customExercises;
  final List<Exercise> originalExercises;
  final ExerciseCategory? category;
  final int selectedLevel;

  const CustomExercisesLoaded({
    required this.customExercises,
    required this.originalExercises,
    this.category,
    this.selectedLevel = 1,
  });

  @override
  List<Object?> get props => [customExercises, originalExercises, category, selectedLevel];
}

/// حالة تم تحميل تمرين مخصص واحد
class CustomExerciseDetailsLoaded extends CustomExercisesState {
  final CustomExercise customExercise;

  const CustomExerciseDetailsLoaded({
    required this.customExercise,
  });

  @override
  List<Object?> get props => [customExercise];
}

/// حالة تم حفظ تمرين مخصص
class CustomExerciseSaved extends CustomExercisesState {
  final CustomExercise customExercise;

  const CustomExerciseSaved({
    required this.customExercise,
  });

  @override
  List<Object?> get props => [customExercise];
}

/// حالة الخطأ
class CustomExercisesError extends CustomExercisesState {
  final String message;

  const CustomExercisesError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
