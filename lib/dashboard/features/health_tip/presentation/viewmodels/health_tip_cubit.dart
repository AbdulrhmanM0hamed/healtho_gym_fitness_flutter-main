import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/health_tip_model.dart';
import '../../data/repositories/health_tip_repository.dart';
import 'health_tip_state.dart';

class HealthTipCubit extends Cubit<HealthTipState> {
  final HealthTipRepository _repository = HealthTipRepository();
  
  HealthTipCubit() : super(const HealthTipState());
  
  // Load health tips
  Future<void> loadHealthTips() async {
    if (state.status == HealthTipStatus.loading) return;
    
    emit(state.copyWith(status: HealthTipStatus.loading));
    
    try {
      // Start fresh
      final items = await _repository.getHealthTipsWithPagination(
        limit: state.pageSize,
        offset: 0
      );
      
      // Get total count
      final totalCount = await _repository.countHealthTips();
      
      emit(state.copyWith(
        status: HealthTipStatus.success,
        healthTips: items,
        totalCount: totalCount,
        currentPage: 0,
        hasMoreItems: items.length < totalCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to load health tips: $e',
      ));
    }
  }
  
  // Load more health tips (pagination)
  Future<void> loadMoreHealthTips() async {
    if (state.status == HealthTipStatus.loading || !state.hasMoreItems) return;
    
    emit(state.copyWith(status: HealthTipStatus.loading));
    
    try {
      final nextPage = state.currentPage + 1;
      final offset = nextPage * state.pageSize;
      
      final items = await _repository.getHealthTipsWithPagination(
        limit: state.pageSize,
        offset: offset
      );
      
      if (items.isEmpty) {
        emit(state.copyWith(hasMoreItems: false));
      } else {
        final updatedList = [...state.healthTips, ...items];
        
        emit(state.copyWith(
          status: HealthTipStatus.success,
          healthTips: updatedList,
          currentPage: nextPage,
          hasMoreItems: updatedList.length < state.totalCount,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to load more health tips: $e',
      ));
    }
  }
  
  // Load featured health tips
  Future<void> loadFeaturedHealthTips({int limit = 5}) async {
    try {
      final featuredTips = await _repository.getFeaturedHealthTips(limit: limit);
      
      emit(state.copyWith(featuredHealthTips: featuredTips));
    } catch (e) {
      print('Error loading featured health tips: $e');
    }
  }
  
  // Get health tip by ID
  Future<void> getHealthTipById(String id) async {
    emit(state.copyWith(status: HealthTipStatus.loading));
    
    try {
      final healthTip = await _repository.getHealthTipById(id);
      
      emit(state.copyWith(
        status: HealthTipStatus.success,
        selectedHealthTip: healthTip,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to load health tip: $e',
      ));
    }
  }
  
  // Add a new health tip without image
  Future<bool> addHealthTip({
    required String title,
    required String subtitle,
    required String content,
    List<String>? tags,
    bool isFeatured = false,
  }) async {
    emit(state.copyWith(status: HealthTipStatus.loading));
    
    try {
      await _repository.createHealthTip(
        title: title,
        subtitle: subtitle,
        content: content,
        tags: tags,
        isFeatured: isFeatured,
      );
      
      // Reload the health tips list
      await loadHealthTips();
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to add health tip: $e',
      ));
      return false;
    }
  }
  
  // Add a new health tip with image
  Future<bool> addHealthTipWithImage({
    required String title,
    required String subtitle,
    required String content,
    required XFile imageFile,
    List<String>? tags,
    bool isFeatured = false,
  }) async {
    emit(state.copyWith(status: HealthTipStatus.loading));
    
    try {
      await _repository.createHealthTipWithImage(
        title: title,
        subtitle: subtitle,
        content: content,
        imageFile: imageFile,
        tags: tags,
        isFeatured: isFeatured,
      );
      
      // Reload the health tips list
      await loadHealthTips();
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to add health tip with image: $e',
      ));
      return false;
    }
  }
  
  // Update a health tip
  Future<bool> updateHealthTip(HealthTipModel healthTip) async {
    emit(state.copyWith(status: HealthTipStatus.loading));
    
    try {
      final result = await _repository.updateHealthTip(healthTip);
      
      if (result) {
        // Find and update the health tip in the list
        final updatedList = state.healthTips.map((tip) {
          if (tip.id == healthTip.id) {
            return healthTip;
          }
          return tip;
        }).toList();
        
        emit(state.copyWith(
          status: HealthTipStatus.success,
          healthTips: updatedList,
          selectedHealthTip: healthTip.id == state.selectedHealthTip?.id 
              ? healthTip 
              : state.selectedHealthTip,
        ));
      } else {
        emit(state.copyWith(
          status: HealthTipStatus.error,
          errorMessage: 'Failed to update health tip',
        ));
      }
      
      return result;
    } catch (e) {
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to update health tip: $e',
      ));
      return false;
    }
  }
  
  // Update a health tip with a new image
  Future<bool> updateHealthTipWithImage(HealthTipModel healthTip, XFile imageFile) async {
    emit(state.copyWith(status: HealthTipStatus.loading));
    
    try {
      final result = await _repository.updateHealthTipWithImage(healthTip, imageFile);
      
      if (result) {
        await loadHealthTips();
      } else {
        emit(state.copyWith(
          status: HealthTipStatus.error,
          errorMessage: 'Failed to update health tip with image',
        ));
      }
      
      return result;
    } catch (e) {
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to update health tip with image: $e',
      ));
      return false;
    }
  }
  
  // Delete a health tip
  Future<bool> deleteHealthTip(String id) async {
    emit(state.copyWith(status: HealthTipStatus.loading));
    
    try {
      final result = await _repository.deleteHealthTip(id);
      
      if (result) {
        // Remove the deleted health tip from the list
        final updatedList = state.healthTips.where((tip) => tip.id != id).toList();
        
        // Update total count
        final newTotalCount = state.totalCount - 1;
        
        emit(state.copyWith(
          status: HealthTipStatus.success,
          healthTips: updatedList,
          totalCount: newTotalCount,
          selectedHealthTip: state.selectedHealthTip?.id == id 
              ? null 
              : state.selectedHealthTip,
        ));
      } else {
        emit(state.copyWith(
          status: HealthTipStatus.error,
          errorMessage: 'Failed to delete health tip',
        ));
      }
      
      return result;
    } catch (e) {
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to delete health tip: $e',
      ));
      return false;
    }
  }
  
  // Toggle featured status
  Future<bool> toggleFeaturedStatus(String id, bool isFeatured) async {
    try {
      final result = await _repository.toggleFeaturedStatus(id, isFeatured);
      
      if (result) {
        // Find and update the health tip in the list
        final updatedList = state.healthTips.map((tip) {
          if (tip.id == id) {
            return tip.copyWith(isFeatured: isFeatured);
          }
          return tip;
        }).toList();
        
        // Update selected health tip if it's the same one
        final updatedSelectedTip = state.selectedHealthTip?.id == id
            ? state.selectedHealthTip!.copyWith(isFeatured: isFeatured)
            : state.selectedHealthTip;
        
        emit(state.copyWith(
          healthTips: updatedList,
          selectedHealthTip: updatedSelectedTip,
        ));
        
        // Refresh featured tips if we have any
        if (state.featuredHealthTips.isNotEmpty) {
          await loadFeaturedHealthTips();
        }
      }
      
      return result;
    } catch (e) {
      print('Error toggling featured status: $e');
      return false;
    }
  }
  
  void reset() {
    emit(const HealthTipState());
  }
} 