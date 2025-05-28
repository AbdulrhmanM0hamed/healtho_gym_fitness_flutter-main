import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/datasources/custom_exercise_local_datasource.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/custom_exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/repositories/exercise_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/custom_exercises_state.dart';

/// Cubit للتعامل مع التمارين المخصصة
class CustomExercisesCubit extends Cubit<CustomExercisesState> {
  final CustomExerciseLocalDataSource _localDataSource;
  final ExerciseRepository _repository;
  
  ExerciseCategory? _selectedCategory;
  int _selectedLevel = 1;

  CustomExercisesCubit(this._localDataSource, this._repository) 
      : super(CustomExercisesInitial());

  /// تحميل التمارين المخصصة والأصلية حسب الفئة والمستوى
  Future<void> loadExercises(ExerciseCategory category, int level) async {
    emit(CustomExercisesLoading());
    _selectedCategory = category;
    _selectedLevel = level;
    
    try {
      // جلب التمارين الأصلية من قاعدة البيانات
      final originalExercises = await _repository.getExercisesByLevel(category.id, level);
      
      // جلب التمارين المخصصة من التخزين المحلي
      final customExercises = await _localDataSource.getCustomExercisesByCategoryAndLevel(category.id, level);
      
      emit(CustomExercisesLoaded(
        customExercises: customExercises,
        originalExercises: originalExercises,
        category: category,
        selectedLevel: level,
      ));
    } catch (e) {
      emit(CustomExercisesError(message: e.toString()));
    }
  }

  /// تحميل تفاصيل تمرين مخصص
  Future<void> loadCustomExerciseDetails(String id) async {
    emit(CustomExercisesLoading());
    
    try {
      final customExercise = await _localDataSource.getCustomExerciseById(id);
      if (customExercise != null) {
        emit(CustomExerciseDetailsLoaded(customExercise: customExercise));
      } else {
        emit(const CustomExercisesError(message: 'لم يتم العثور على التمرين المخصص'));
      }
    } catch (e) {
      emit(CustomExercisesError(message: e.toString()));
    }
  }

  /// إنشاء تمرين مخصص من تمرين أصلي
  Future<void> createCustomExerciseFromOriginal(Exercise exercise) async {
    emit(CustomExercisesLoading());
    
    try {
      // التحقق مما إذا كان هناك تمرين مخصص موجود بالفعل
      final existingCustom = await _localDataSource.getCustomExerciseByOriginalId(exercise.id);
      
      if (existingCustom != null) {
        emit(CustomExerciseDetailsLoaded(customExercise: existingCustom));
      } else {
        // إنشاء تمرين مخصص جديد
        final customExercise = CustomExercise.fromExercise(exercise);
        await _localDataSource.saveCustomExercise(customExercise);
        emit(CustomExerciseSaved(customExercise: customExercise));
      }
    } catch (e) {
      emit(CustomExercisesError(message: e.toString()));
    }
  }

  /// إنشاء تمرين مخصص جديد تماماً
  Future<void> createNewCustomExercise({
    required int categoryId,
    required String title,
    required String description,
    required int level,
    String mainImageUrl = '',
    List<String> imageUrl = const [],
    double lastWeight = 0,
    int lastReps = 0,
    int lastSets = 0,
    String notes = '',
  }) async {
    emit(CustomExercisesLoading());
    
    try {
      final customExercise = CustomExercise.create(
        categoryId: categoryId,
        title: title,
        description: description,
        level: level,
        mainImageUrl: mainImageUrl,
        imageUrl: imageUrl,
        lastWeight: lastWeight,
        lastReps: lastReps,
        lastSets: lastSets,
        notes: notes,
      );
      
      await _localDataSource.saveCustomExercise(customExercise);
      emit(CustomExerciseSaved(customExercise: customExercise));
      
      // إعادة تحميل التمارين إذا كان هناك فئة محددة
      if (_selectedCategory != null) {
        await loadExercises(_selectedCategory!, _selectedLevel);
      }
    } catch (e) {
      emit(CustomExercisesError(message: e.toString()));
    }
  }

  /// تحديث تمرين مخصص
  Future<void> updateCustomExercise(CustomExercise exercise) async {
    emit(CustomExercisesLoading());
    
    try {
      await _localDataSource.saveCustomExercise(exercise);
      emit(CustomExerciseSaved(customExercise: exercise));
      
      // إعادة تحميل التمارين إذا كان هناك فئة محددة
      if (_selectedCategory != null) {
        await loadExercises(_selectedCategory!, _selectedLevel);
      }
    } catch (e) {
      emit(CustomExercisesError(message: e.toString()));
    }
  }

  /// حذف تمرين مخصص
  Future<void> deleteCustomExercise(String id, String? localImagePath) async {
    emit(CustomExercisesLoading());
    
    try {
      await _localDataSource.deleteCustomExercise(id);
      
      // حذف الصورة المحلية إذا كانت موجودة
      if (localImagePath != null && localImagePath.isNotEmpty) {
        await _localDataSource.deleteExerciseImage(localImagePath);
      }
      
      // إعادة تحميل التمارين إذا كان هناك فئة محددة
      if (_selectedCategory != null) {
        await loadExercises(_selectedCategory!, _selectedLevel);
      } else {
        emit(CustomExercisesInitial());
      }
    } catch (e) {
      emit(CustomExercisesError(message: e.toString()));
    }
  }

  /// تحديث الوزن الأخير للتمرين
  Future<void> updateLastWeight(String id, double weight, int reps, int sets) async {
    try {
      final exercise = await _localDataSource.getCustomExerciseById(id);
      if (exercise != null) {
        final updated = exercise.copyWith(
          lastWeight: weight,
          lastReps: reps,
          lastSets: sets,
          updatedAt: DateTime.now(),
        );
        
        await _localDataSource.saveCustomExercise(updated);
        
        // إذا كانت الحالة الحالية هي تفاصيل التمرين، قم بتحديثها
        if (state is CustomExerciseDetailsLoaded) {
          emit(CustomExerciseDetailsLoaded(customExercise: updated));
        }
      }
    } catch (e) {
      // لا نريد إظهار خطأ للمستخدم هنا، فقط سجل الخطأ
      print('Error updating last weight: $e');
    }
  }

  /// تحديث صورة التمرين
  Future<void> updateExerciseImage(String id, XFile imageFile) async {
    emit(CustomExercisesLoading());
    
    try {
      final exercise = await _localDataSource.getCustomExerciseById(id);
      if (exercise != null) {
        // حذف الصورة القديمة إذا كانت موجودة
        if (exercise.localImagePath.isNotEmpty) {
          await _localDataSource.deleteExerciseImage(exercise.localImagePath);
        }
        
        // حفظ الصورة الجديدة
        final imagePath = await _localDataSource.saveExerciseImage(imageFile);
        
        // تحديث التمرين
        final updated = exercise.copyWith(
          localImagePath: imagePath,
          updatedAt: DateTime.now(),
        );
        
        await _localDataSource.saveCustomExercise(updated);
        emit(CustomExerciseDetailsLoaded(customExercise: updated));
      } else {
        emit(const CustomExercisesError(message: 'لم يتم العثور على التمرين المخصص'));
      }
    } catch (e) {
      emit(CustomExercisesError(message: e.toString()));
    }
  }

  /// تبديل حالة المفضلة للتمرين
  Future<void> toggleFavorite(String id) async {
    try {
      final exercise = await _localDataSource.getCustomExerciseById(id);
      if (exercise != null) {
        final updated = exercise.copyWith(
          isFavorite: !exercise.isFavorite,
          updatedAt: DateTime.now(),
        );
        
        await _localDataSource.saveCustomExercise(updated);
        
        // إذا كانت الحالة الحالية هي تفاصيل التمرين، قم بتحديثها
        if (state is CustomExerciseDetailsLoaded) {
          emit(CustomExerciseDetailsLoaded(customExercise: updated));
        }
      }
    } catch (e) {
      // لا نريد إظهار خطأ للمستخدم هنا، فقط سجل الخطأ
      print('Error toggling favorite: $e');
    }
  }
}
