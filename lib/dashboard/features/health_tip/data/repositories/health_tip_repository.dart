import 'package:image_picker/image_picker.dart';
import '../models/health_tip_model.dart';
import '../services/health_tip_service.dart';
import '../services/storage_service.dart';

class HealthTipRepository {
  final HealthTipService _healthTipService = HealthTipService();
  final HealthTipStorageService _storageService = HealthTipStorageService();
  
  // Get all health tips
  Future<List<HealthTipModel>> getAllHealthTips() async {
    return await _healthTipService.getAllHealthTips();
  }
  
  // Get all health tips with pagination
  Future<List<HealthTipModel>> getHealthTipsWithPagination({
    required int limit, 
    required int offset
  }) async {
    return await _healthTipService.getHealthTipsWithPagination(
      limit: limit, 
      offset: offset
    );
  }
  
  // Get featured health tips
  Future<List<HealthTipModel>> getFeaturedHealthTips({int limit = 5}) async {
    return await _healthTipService.getFeaturedHealthTips(limit: limit);
  }
  
  // Get specific health tip by ID
  Future<HealthTipModel?> getHealthTipById(String id) async {
    return await _healthTipService.getHealthTipById(id);
  }
  
  // Create a new health tip without an image
  Future<String> createHealthTip({
    required String title,
    required String subtitle,
    required String content,
    List<String>? tags,
    bool isFeatured = false,
  }) async {
    final id = _healthTipService.generateUniqueId();
    
    final healthTip = HealthTipModel(
      id: id,
      title: title,
      subtitle: subtitle,
      content: content,
      createdAt: DateTime.now(),
      tags: tags,
      isFeatured: isFeatured,
    );
    
    return await _healthTipService.addHealthTip(healthTip);
  }
  
  // Create a new health tip with an image
  Future<String?> createHealthTipWithImage({
    required String title,
    required String subtitle,
    required String content,
    required XFile imageFile,
    List<String>? tags,
    bool isFeatured = false,
  }) async {
    try {
      final id = _healthTipService.generateUniqueId();
      
      // Upload image with the storage service
      final imageUrl = await _storageService.uploadImage(imageFile, id);
      print('Repository received imageUrl: $imageUrl');
      
      // Create the health tip with the image URL
      final healthTip = HealthTipModel(
        id: id,
        title: title,
        subtitle: subtitle,
        content: content,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        tags: tags,
        isFeatured: isFeatured,
      );
      
      print('Health tip with image being saved: ${healthTip.toJson()}');
      
      return await _healthTipService.addHealthTip(healthTip);
    } catch (e) {
      print('Error creating health tip with image: $e');
      return null;
    }
  }
  
  // Update a health tip
  Future<bool> updateHealthTip(HealthTipModel healthTip) async {
    try {
      await _healthTipService.updateHealthTip(healthTip);
      return true;
    } catch (e) {
      print('Error updating health tip: $e');
      return false;
    }
  }
  
  // Update a health tip with a new image
  Future<bool> updateHealthTipWithImage(HealthTipModel healthTip, XFile imageFile) async {
    try {
      // Upload the new image
      final imageUrl = await _storageService.uploadImage(imageFile, healthTip.id);
      
      // Update the health tip with the new image URL
      final updatedHealthTip = healthTip.copyWith(imageUrl: imageUrl);
      
      await _healthTipService.updateHealthTip(updatedHealthTip);
      return true;
    } catch (e) {
      print('Error updating health tip with image: $e');
      return false;
    }
  }
  
  // Delete a health tip
  Future<bool> deleteHealthTip(String id) async {
    try {
      final healthTip = await _healthTipService.getHealthTipById(id);
      if (healthTip != null && healthTip.imageUrl != null) {
        // Delete image if exists
        await _storageService.deleteImage(healthTip.imageUrl!);
      }
      
      await _healthTipService.deleteHealthTip(id);
      return true;
    } catch (e) {
      print('Error deleting health tip: $e');
      return false;
    }
  }
  
  // Toggle featured status
  Future<bool> toggleFeaturedStatus(String id, bool isFeatured) async {
    try {
      await _healthTipService.toggleFeaturedStatus(id, isFeatured);
      return true;
    } catch (e) {
      print('Error toggling featured status: $e');
      return false;
    }
  }
  
  // Count total health tips
  Future<int> countHealthTips() async {
    return await _healthTipService.countHealthTips();
  }
} 