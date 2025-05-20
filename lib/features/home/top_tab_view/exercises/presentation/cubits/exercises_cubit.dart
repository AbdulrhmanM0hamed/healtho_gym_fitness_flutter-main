import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/repositories/exercise_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'exercises_state.dart';

class ExercisesCubit extends Cubit<ExercisesState> {
  final ExerciseRepository _repository;
  ExerciseCategory? _selectedCategory;
  int _selectedLevel = 1;
  
  ExercisesCubit(this._repository) 
    : super(ExercisesInitial());

  // تحميل التمارين حسب الفئة
  void loadExercisesByCategory(ExerciseCategory category) async {
    print('DEBUG: Loading exercises for category: ${category.id} - ${category.titleAr}');
    _selectedCategory = category;
    emit(ExercisesLoading());
    
    try {
      final exercises = await _repository.getExercisesByLevel(category.id, _selectedLevel);
      print('DEBUG: Loaded ${exercises.length} exercises for level $_selectedLevel');
      print('DEBUG: Exercise titles: ${exercises.map((e) => e.title).join(', ')}');
      print('DEBUG: Exercise images: ${exercises.map((e) => e.mainImageUrl).join(', ')}');
      emit(ExercisesLoaded(
        exercises: exercises, 
        category: category,
        selectedLevel: _selectedLevel
      ));
    } catch (e) {
      print('DEBUG: Error loading exercises: $e');
      emit(ExercisesError(message: e.toString()));
    }
  }

  // تعيين المستوى وتحميل التمارين حسب المستوى
  void setLevel(int level) async {
    print('DEBUG: Setting level to $level');
    _selectedLevel = level;
    if (_selectedCategory != null) {
      emit(ExercisesLoading());
      
      try {
        final exercises = await _repository.getExercisesByLevel(
          _selectedCategory!.id, 
          level
        );
        print('DEBUG: Loaded ${exercises.length} exercises for level $level');
        print('DEBUG: Exercise titles: ${exercises.map((e) => e.title).join(', ')}');
        emit(ExercisesLoaded(
          exercises: exercises,
          category: _selectedCategory!,
          selectedLevel: level
        ));
      } catch (e) {
        print('DEBUG: Error setting level: $e');
        emit(ExercisesError(message: e.toString()));
      }
    }
  }

  // تغيير حالة المفضلة
  void toggleFavorite(Exercise exercise) async {
    try {
      print('DEBUG: Toggling favorite for exercise ${exercise.id} - ${exercise.title}');
      final newIsFavorite = !exercise.isFavorite;
      await _repository.toggleFavorite(exercise.id, newIsFavorite);
      
      if (state is ExercisesLoaded) {
        final currentState = state as ExercisesLoaded;
        // Create a new list of exercises with the updated favorite state
        final updatedExercises = currentState.exercises.map((e) {
          if (e.id == exercise.id) {
            // Create a new Exercise object with updated isFavorite
            return Exercise(
              id: e.id,
              categoryId: e.categoryId,
              title: e.title,
              description: e.description,
              mainImageUrl: e.mainImageUrl,
              level: e.level,
              isFavorite: newIsFavorite,
              createdAt: e.createdAt,
              updatedAt: DateTime.now(),
              imageUrl: e.imageUrl,
            );
          }
          return e;
        }).toList();
        
        print('DEBUG: Updated favorite state to $newIsFavorite');
        emit(ExercisesLoaded(
          exercises: updatedExercises,
          category: currentState.category,
          selectedLevel: currentState.selectedLevel
        ));
      }
    } catch (e) {
      print('DEBUG: Error toggling favorite: $e');
      // We don't change the UI state because of a favorite toggle error
    }
  }
} 