import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/repositories/exercise_repository.dart';

part 'exercises_category_state.dart';

class ExercisesCategoryCubit extends Cubit<ExercisesCategoryState> {
  final ExerciseRepository _repository;
  
  ExercisesCategoryCubit(this._repository) 
    : super(ExercisesCategoryInitial());

  // تحميل فئات التمارين
  Future<void> loadCategories() async {
    emit(ExercisesCategoryLoading());
    
    try {
      final categories = await _repository.getExerciseCategories();
      emit(ExercisesCategoryLoaded(categories: categories));
    } catch (error) {
      emit(ExercisesCategoryError(message: error.toString()));
    }
  }
}

