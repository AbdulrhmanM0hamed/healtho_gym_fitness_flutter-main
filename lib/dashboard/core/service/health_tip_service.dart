import 'dart:io';
import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/models/health_tip_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class HealthTipService {
  final SupabaseClient _client = SupabaseService.supabase;
  final String _tableName = 'health_tips';
  final String _bucketName = 'healthtip';

  Future<List<HealthTipModel>> getHealthTips() async {
    try {
      final data = await _client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);
      
      return (data as List<dynamic>).map((json) => HealthTipModel.fromJson(json)).toList();
    } catch (e) {
      LoggerUtil.error('Exception getting health tips: $e');
      throw Exception('Failed to get health tips: $e');
    }
  }

  Future<HealthTipModel?> getHealthTipById(String id) async {
    try {
      final data = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      if (data == null) {
        return null;
      }

      return HealthTipModel.fromJson(data);
    } catch (e) {
      LoggerUtil.error('Exception getting health tip by id: $e');
      throw Exception('Failed to get health tip: $e');
    }
  }

  Future<List<HealthTipModel>> getFeaturedHealthTips() async {
    try {
      final data = await _client
          .from(_tableName)
          .select()
          .eq('is_featured', true)
          .order('created_at', ascending: false);
      
      return (data as List<dynamic>).map((json) => HealthTipModel.fromJson(json)).toList();
    } catch (e) {
      LoggerUtil.error('Exception getting featured health tips: $e');
      throw Exception('Failed to get featured health tips: $e');
    }
  }

  Future<void> updateLikes(String tipId, int likes) async {
    try {
      await _client
          .from(_tableName)
          .update({'likes': likes})
          .eq('id', tipId);
    } catch (e) {
      LoggerUtil.error('Exception updating health tip likes: $e');
      throw Exception('Failed to update likes: $e');
    }
  }
  
  // رفع صورة نصيحة صحية
  Future<String> uploadHealthTipImage(File imageFile, String tipId) async {
    try {
      final fileExt = path.extension(imageFile.path); // .jpg, .png, etc.
      final fileName = 'health_tip_$tipId$fileExt';
      
      final response = await _client.storage
          .from(_bucketName)
          .upload(fileName, imageFile);
      
      // إنشاء رابط URL للصورة
      final imageUrl = _client.storage
          .from(_bucketName)
          .getPublicUrl(fileName);
      
      // تحديث معلومات النصيحة الصحية بعنوان URL للصورة
      await _client
          .from(_tableName)
          .update({'image_url': imageUrl})
          .eq('id', tipId);
      
      return imageUrl;
    } catch (e) {
      LoggerUtil.error('Exception uploading health tip image: $e');
      throw Exception('Failed to upload health tip image: $e');
    }
  }
  
  // حذف صورة نصيحة صحية
  Future<void> deleteHealthTipImage(String imagePath) async {
    try {
      final fileName = path.basename(imagePath);
      
      await _client.storage
          .from(_bucketName)
          .remove([fileName]);
    } catch (e) {
      LoggerUtil.error('Exception deleting health tip image: $e');
      throw Exception('Failed to delete health tip image: $e');
    }
  }
} 