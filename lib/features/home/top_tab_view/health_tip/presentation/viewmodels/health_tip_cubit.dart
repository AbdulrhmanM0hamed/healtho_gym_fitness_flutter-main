import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/models/health_tip_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/repositories/health_tip_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_state.dart';

class HealthTipCubit extends Cubit<HealthTipState> {
  final HealthTipRepository _repository;

  HealthTipCubit(this._repository) : super(const HealthTipState());

  Future<void> getHealthTips() async {
    try {
      emit(state.copyWith(status: HealthTipStatus.loading));
      
      final healthTips = await _repository.getHealthTips();
      
      emit(state.copyWith(
        status: HealthTipStatus.loaded,
        healthTips: healthTips,
      ));
    } catch (e) {
      LoggerUtil.error('Error loading health tips: $e');
      emit(state.copyWith(
        status: HealthTipStatus.error,
        errorMessage: 'Failed to load health tips: $e',
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
      final newLikes = currentLikes + 1;
      await _repository.updateLikes(tipId, newLikes);
      
      if (state.selectedTip != null && state.selectedTip!.id == tipId) {
        final updatedTip = state.selectedTip!.copyWith(likes: newLikes);
        emit(state.copyWith(selectedTip: updatedTip));
      }
      
      // Also update in the list if present
      final updatedList = state.healthTips.map((tip) {
        if (tip.id == tipId) {
          return tip.copyWith(likes: newLikes);
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