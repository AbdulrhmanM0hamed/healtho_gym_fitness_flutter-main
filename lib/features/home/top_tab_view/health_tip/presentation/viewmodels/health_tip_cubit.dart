import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/models/health_tip_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/repositories/health_tip_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_state.dart';

class HealthTipCubit extends Cubit<HealthTipState> {
  final HealthTipRepository _repository;
  
  // متغير لتخزين طابع زمني للتحديث
  String refreshTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  HealthTipCubit(this._repository) : super(const HealthTipState());

  // Load first page of health tips
  Future<void> getHealthTips() async {
    try {
      emit(state.copyWith(status: HealthTipStatus.loading));
      
      // Get total count first for pagination
      final totalCount = await _repository.getHealthTipsCount();
      
      final healthTips = await _repository.getHealthTips(
        limit: state.itemsPerPage,
        offset: 0,
      );
      
      final hasReachedMax = healthTips.length >= totalCount;
      
      emit(state.copyWith(
        status: HealthTipStatus.loaded,
        healthTips: healthTips,
        hasReachedMax: hasReachedMax,
        currentPage: 0,
        totalItems: totalCount,
      ));
    } catch (e) {
      LoggerUtil.error('Error loading health tips: $e');
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to load health tips: $e',
      ));
    }
  }
  
  // Load next page of health tips
  Future<void> loadNextPage() async {
    if (state.hasReachedMax) return;
    
    try {
      if (state.status == HealthTipStatus.loadingMore) return;
      
      emit(state.copyWith(status: HealthTipStatus.loadingMore));
      
      final nextPage = state.currentPage + 1;
      final offset = nextPage * state.itemsPerPage;
      
      final newItems = await _repository.getHealthTips(
        limit: state.itemsPerPage,
        offset: offset,
      );
      
      if (newItems.isEmpty) {
        emit(state.copyWith(
          status: HealthTipStatus.loaded,
          hasReachedMax: true,
        ));
        return;
      }
      
      final allItems = [...state.healthTips, ...newItems];
      final hasReachedMax = allItems.length >= state.totalItems;
      
      emit(state.copyWith(
        status: HealthTipStatus.loaded,
        healthTips: allItems,
        hasReachedMax: hasReachedMax,
        currentPage: nextPage,
      ));
    } catch (e) {
      LoggerUtil.error('Error loading more health tips: $e');
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to load more health tips: $e',
      ));
    }
  }
  
  // تفريغ ذاكرة التخزين المؤقت للصورة بمعرف محدد
  Future<void> clearImageCache(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        await DefaultCacheManager().removeFile(imageUrl);
      }
    } catch (e) {
      LoggerUtil.error('Error clearing image cache: $e');
    }
  }

  // Refresh health tips and start from first page
  Future<void> refreshHealthTips() async {
    try {
      // تحديث الطابع الزمني للتجديد
      refreshTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      // محاولة مسح ذاكرة التخزين المؤقت للصور
      try {
        await DefaultCacheManager().emptyCache();
      } catch (e) {
        LoggerUtil.error('Error clearing image cache: $e');
      }
      
      // إعادة تعيين حالة التطبيق للبدء من الصفحة الأولى
      emit(state.copyWith(
        status: HealthTipStatus.loading,
        currentPage: 0,
        hasReachedMax: false,
        healthTips: [], // تفريغ القائمة لضمان تحميل بيانات جديدة تماماً
      ));
      
      // تحميل البيانات الجديدة
      final totalCount = await _repository.getHealthTipsCount();
      
      final healthTips = await _repository.getHealthTips(
        limit: state.itemsPerPage,
        offset: 0,
      );
      
      final hasReachedMax = healthTips.length >= totalCount;
      
      emit(state.copyWith(
        status: HealthTipStatus.loaded,
        healthTips: healthTips,
        hasReachedMax: hasReachedMax,
        currentPage: 0,
        totalItems: totalCount,
      ));
    } catch (e) {
      LoggerUtil.error('Error refreshing health tips: $e');
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to refresh health tips: $e',
      ));
    }
  }

  Future<void> getHealthTipById(String id) async {
    try {
      emit(state.copyWith(status: HealthTipStatus.loading));
      
      final healthTip = await _repository.getHealthTipById(id);
      
      if (healthTip == null) {
        emit(state.copyWith(
          status: HealthTipStatus.error,
          errorMessage: 'Health tip not found',
        ));
        return;
      }
      
      emit(state.copyWith(
        status: HealthTipStatus.loaded,
        selectedTip: healthTip,
      ));
    } catch (e) {
      LoggerUtil.error('Error loading health tip: $e');
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to load health tip: $e',
      ));
    }
  }

  Future<void> updateLikes(String tipId, int currentLikes) async {
    try {
      await _repository.updateLikes(tipId, currentLikes);
      
      if (state.selectedTip != null && state.selectedTip!.id == tipId) {
        final updatedTip = state.selectedTip!.copyWith(likes: currentLikes);
        emit(state.copyWith(selectedTip: updatedTip));
      }
      
      // Also update in the list if present
      final updatedList = state.healthTips.map((tip) {
        if (tip.id == tipId) {
          return tip.copyWith(likes: currentLikes);
        }
        return tip;
      }).toList();
      
      emit(state.copyWith(healthTips: updatedList));
    } catch (e) {
      LoggerUtil.error('Error updating likes: $e');
      // We could emit an error state, but for likes it might be better
      // to just log it and not disrupt the user experience
    }
  }
  
  Future<void> uploadHealthTipImage(File imageFile, String tipId) async {
    try {
      emit(state.copyWith(status: HealthTipStatus.loading));
      
      final imageUrl = await _repository.uploadHealthTipImage(imageFile, tipId);
      
      // Update the selected tip if it's the one we're uploading for
      if (state.selectedTip != null && state.selectedTip!.id == tipId) {
        final updatedTip = state.selectedTip!.copyWith(imageUrl: imageUrl);
        emit(state.copyWith(
          status: HealthTipStatus.loaded,
          selectedTip: updatedTip
        ));
      }
      
      // Also update in the list if present
      final updatedList = state.healthTips.map((tip) {
        if (tip.id == tipId) {
          return tip.copyWith(imageUrl: imageUrl);
        }
        return tip;
      }).toList();
      
      emit(state.copyWith(
        status: HealthTipStatus.loaded,
        healthTips: updatedList
      ));
    } catch (e) {
      LoggerUtil.error('Error uploading image: $e');
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to upload image: $e',
      ));
    }
  }
  
  Future<void> deleteHealthTipImage(String imagePath, String tipId) async {
    try {
      emit(state.copyWith(status: HealthTipStatus.loading));
      
      await _repository.deleteHealthTipImage(imagePath);
      
      // Update the selected tip if it's the one we're deleting image for
      if (state.selectedTip != null && state.selectedTip!.id == tipId) {
        final updatedTip = state.selectedTip!.copyWith(imageUrl: null);
        emit(state.copyWith(
          status: HealthTipStatus.loaded,
          selectedTip: updatedTip
        ));
      }
      
      // Also update in the list if present
      final updatedList = state.healthTips.map((tip) {
        if (tip.id == tipId) {
          return tip.copyWith(imageUrl: null);
        }
        return tip;
      }).toList();
      
      emit(state.copyWith(
        status: HealthTipStatus.loaded,
        healthTips: updatedList
      ));
    } catch (e) {
      LoggerUtil.error('Error deleting image: $e');
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to delete image: $e',
      ));
    }
  }
} 