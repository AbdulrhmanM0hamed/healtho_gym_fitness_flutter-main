import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/utils/error_util.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/core/services/storage_service.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/models/exercise_model.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/repositories/exercise_repository.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepository _repository;
  final StorageService _storageService;
  bool _isClosed = false;

  ExerciseCubit(this._repository, this._storageService) : super(ExerciseInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  // Safe emit that checks if cubit is still active
  void safeEmit(ExerciseState state) {
    if (!_isClosed) {
      emit(state);
    } else {
      LoggerUtil.info('Attempted to emit state after cubit was closed');
    }
  }

  // Load exercises by category and level
  Future<void> loadExercises(int categoryId, int level) async {
    try {
      safeEmit(ExerciseLoading());
      final exercises = await _repository.getExercisesByLevel(categoryId, level);
      safeEmit(ExerciseLoaded(
        exercises: exercises,
        categoryId: categoryId,
        selectedLevel: level,
      ));
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error loading exercises', e);
      safeEmit(ExerciseError(errorMessage));
    }
  }

  // Add new exercise
  Future<void> addExercise({
    required int categoryId,
    required String title,
    required String description,
    required File mainImage,
    required List<File> images,
    required int level,
  }) async {
    if (_isClosed) return;

    try {
      safeEmit(ExerciseAdding());
      
      // Upload main image
      final mainImageUrl = await _storageService.uploadExerciseMainImage(
        mainImage,
        categoryId,
      );

      // Upload additional images
      final imageUrls = await _storageService.uploadExerciseGalleryImages(
        images,
        categoryId,
      );

      // Add exercise to database
      final exercise = await _repository.addExercise(
        categoryId: categoryId,
        title: title,
        description: description,
        mainImageUrl: mainImageUrl,
        imageUrl: imageUrls,
        level: level,
      );
      
      safeEmit(ExerciseAdded(exercise));
      loadExercises(categoryId, level); // Reload the list
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error adding exercise', e);
      safeEmit(ExerciseError(errorMessage));
    }
  }

  // Update exercise
  Future<void> updateExercise(Exercise exercise, {
    String? title,
    String? description,
    int? level,
    File? mainImage,
    List<File>? images
  }) async {
    if (_isClosed) return;

    try {
      safeEmit(ExerciseUpdating());
      LoggerUtil.info('Updating exercise ${exercise.id}');
      LoggerUtil.info('New title: $title');
      LoggerUtil.info('New description: $description');
      LoggerUtil.info('New level: $level');

      String mainImageUrl = exercise.mainImageUrl;
      List<String> imageUrls = exercise.imageUrl;

      // Update main image if provided
      if (mainImage != null) {
        LoggerUtil.info('Uploading new main image');
        // Delete old main image
        try {
          await _storageService.deleteExerciseImage(exercise.mainImageUrl);
        } catch (e) {
          LoggerUtil.error('Error deleting old main image', e);
        }
        // Upload new main image
        mainImageUrl = await _storageService.uploadExerciseMainImage(
          mainImage,
          exercise.categoryId,
        );
      }

      // Update additional images if provided
      if (images != null && images.isNotEmpty) {
        LoggerUtil.info('Uploading new additional images');
        // Delete old images
        try {
          await _storageService.deleteExerciseImages(exercise.imageUrl);
        } catch (e) {
          LoggerUtil.error('Error deleting old images', e);
        }
        // Upload new images
        imageUrls = await _storageService.uploadExerciseGalleryImages(
          images,
          exercise.categoryId,
        );
      }

      // Update exercise in database
      final updatedExercise = exercise.copyWith(
        title: title,
        description: description,
        level: level,
        mainImageUrl: mainImageUrl,
        imageUrl: imageUrls,
      );
      
      LoggerUtil.info('Saving updated exercise to database');
      await _repository.updateExercise(updatedExercise);
      
      safeEmit(ExerciseUpdated(updatedExercise));
      loadExercises(exercise.categoryId, updatedExercise.level); // Use updated level
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error updating exercise', e);
      safeEmit(ExerciseError(errorMessage));
    }
  }

  // Delete exercise
  Future<void> deleteExercise(Exercise exercise) async {
    if (_isClosed) return;

    try {
      safeEmit(ExerciseDeleting());

      // Delete images from storage
      await _storageService.deleteExerciseImage(exercise.mainImageUrl);
      await _storageService.deleteExerciseImages(exercise.imageUrl);

      // Delete exercise from database
      await _repository.deleteExercise(exercise.id);
      
      safeEmit(ExerciseDeleted(exercise.id));
      loadExercises(exercise.categoryId, exercise.level); // Reload the list
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error deleting exercise', e);
      safeEmit(ExerciseError(errorMessage));
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Exercise exercise) async {
    if (_isClosed) return;

    try {
      final newIsFavorite = !exercise.isFavorite;
      safeEmit(ExerciseTogglingFavorite());
      await _repository.toggleFavorite(exercise.id, newIsFavorite);
      safeEmit(ExerciseToggledFavorite(exercise.id, newIsFavorite));
      loadExercises(exercise.categoryId, exercise.level); // Reload the list
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error toggling favorite', e);
      safeEmit(ExerciseError(errorMessage));
    }
  }
} 