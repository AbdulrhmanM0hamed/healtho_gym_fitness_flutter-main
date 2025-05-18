import 'dart:io';
import 'package:healtho_gym/dashboard/core/service/health_tip_service.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/models/health_tip_model.dart';

class HealthTipRepository {
  final HealthTipService _healthTipService;

  HealthTipRepository(this._healthTipService);

  Future<List<HealthTipModel>> getHealthTips({int limit = 10, int offset = 0}) async {
    return await _healthTipService.getHealthTips(limit: limit, offset: offset);
  }
  
  Future<int> getHealthTipsCount() async {
    return await _healthTipService.getHealthTipsCount();
  }

  Future<HealthTipModel?> getHealthTipById(String id) async {
    return await _healthTipService.getHealthTipById(id);
  }

  Future<List<HealthTipModel>> getFeaturedHealthTips() async {
    return await _healthTipService.getFeaturedHealthTips();
  }

  Future<void> updateLikes(String tipId, int likes) async {
    await _healthTipService.updateLikes(tipId, likes);
  }
  
  Future<String> uploadHealthTipImage(File imageFile, String tipId) async {
    return await _healthTipService.uploadHealthTipImage(imageFile, tipId);
  }
  
  Future<void> deleteHealthTipImage(String imagePath) async {
    await _healthTipService.deleteHealthTipImage(imagePath);
  }
} 