import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/utils/error_util.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/core/services/storage_service.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/models/exercise_category_model.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/repositories/exercise_category_repository.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_state.dart';

class ExerciseCategoryCubit extends Cubit<ExerciseCategoryState> {
  final ExerciseCategoryRepository _repository;
  final StorageService _storageService;
  bool _isClosed = false;

  ExerciseCategoryCubit(this._repository, this._storageService) : super(ExerciseCategoryInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  void safeEmit(ExerciseCategoryState state) {
    if (!_isClosed) {
      emit(state);
    } else {
      LoggerUtil.info('Attempted to emit state after cubit was closed');
    }
  }

  Future<void> loadCategories() async {
    try {
      safeEmit(ExerciseCategoryLoading());
      final categories = await _repository.getCategories();
      safeEmit(ExerciseCategoryLoaded(categories));
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error loading categories', e);
      safeEmit(ExerciseCategoryError(errorMessage));
    }
  }

  Future<void> addCategory({
    required String titleAr,
    required String title,
    required File image,
  }) async {
    try {
      safeEmit(ExerciseCategoryAdding());
      
      // Upload image
      final imageUrl = await _storageService.uploadCategoryImage(image);

      // Add category to database
      final category = await _repository.addCategory(
        titleAr: titleAr,
        title: title,
        imageUrl: imageUrl,
      );
      
      safeEmit(ExerciseCategoryAdded(category));
      loadCategories();
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error adding category', e);
      safeEmit(ExerciseCategoryError(errorMessage));
    }
  }

  Future<void> updateCategory(ExerciseCategory category, {File? image}) async {
    try {
      safeEmit(ExerciseCategoryUpdating());

      String imageUrl = category.imageUrl;
      if (image != null) {
        // Delete old image
        await _storageService.deleteCategoryImage(category.imageUrl);
        // Upload new image
        imageUrl = await _storageService.uploadCategoryImage(image);
      }

      // Update category in database
      final updatedCategory = category.copyWith(imageUrl: imageUrl);
      await _repository.updateCategory(updatedCategory);
      
      safeEmit(ExerciseCategoryUpdated(updatedCategory));
      loadCategories();
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error updating category', e);
      safeEmit(ExerciseCategoryError(errorMessage));
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      safeEmit(ExerciseCategoryDeleting());

      // Get category to delete its image
      final category = await _repository.getCategory(id);
      if (category != null) {
        // Delete image from storage
        await _storageService.deleteCategoryImage(category.imageUrl);
      }

      // Delete category from database
      await _repository.deleteCategory(id);
      
      safeEmit(ExerciseCategoryDeleted(id));
      loadCategories();
    } catch (e) {
      final errorMessage = ErrorUtil.getErrorMessage(e);
      LoggerUtil.error('Error deleting category', e);
      safeEmit(ExerciseCategoryError(errorMessage));
    }
  }
} 