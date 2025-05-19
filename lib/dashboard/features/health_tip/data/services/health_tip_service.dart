import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/health_tip_model.dart';
import 'package:healtho_gym/core/services/one_signal_notification_service.dart';
import 'package:healtho_gym/core/di/service_locator.dart';

class HealthTipService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'health_tips';
  
  // Get all health tips
  Future<List<HealthTipModel>> getAllHealthTips({bool descending = true}) async {
    final response = await _supabase
        .from(_tableName)
        .select()
        .order('created_at', ascending: !descending);
    
    return (response as List)
        .map((item) => HealthTipModel.fromJson(item))
        .toList();
  }
  
  // Get health tips with pagination
  Future<List<HealthTipModel>> getHealthTipsWithPagination({
    required int limit, 
    required int offset,
    bool descending = true
  }) async {
    final response = await _supabase
        .from(_tableName)
        .select()
        .order('created_at', ascending: !descending)
        .range(offset, offset + limit - 1);
    
    return (response as List)
        .map((item) => HealthTipModel.fromJson(item))
        .toList();
  }
  
  // Get featured health tips
  Future<List<HealthTipModel>> getFeaturedHealthTips({int limit = 5}) async {
    final response = await _supabase
        .from(_tableName)
        .select()
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(limit);
    
    return (response as List)
        .map((item) => HealthTipModel.fromJson(item))
        .toList();
  }
  
  // Get a specific health tip
  Future<HealthTipModel?> getHealthTipById(String id) async {
    final response = await _supabase
        .from(_tableName)
        .select()
        .eq('id', id)
        .single();
    
    if (response == null) {
      return null;
    }
    
    return HealthTipModel.fromJson(response);
  }
  
  // Add a new health tip
  Future<String> addHealthTip(HealthTipModel healthTip) async {
    await _supabase
        .from(_tableName)
        .insert(healthTip.toJson());
    
    // إرسال إشعار بعد إضافة النصيحة بنجاح
    try {
      final notificationService = sl<OneSignalNotificationService>();
      
      // 1. إرسال إشعار محلي للجهاز الحالي
      await notificationService.sendNewHealthTipNotification(healthTip);
      print('تم إرسال الإشعار المحلي بنجاح للنصيحة الجديدة: ${healthTip.title}');
      
      // 2. محاولة إرسال الإشعار عبر خادم OneSignal لجميع المستخدمين
      try {
        await notificationService.sendNotificationViaServer(
          healthTip.title,
          healthTip.subtitle,
        );
        print('تم إرسال الإشعار بنجاح لجميع المستخدمين');
      } catch (serverError) {
        print('لم يتم إرسال الإشعار عبر الخادم: $serverError');
        // استمر في العملية حتى لو فشل إرسال الإشعار عبر الخادم
      }
    } catch (e) {
      print('خطأ في إرسال الإشعار: $e');
      // نستمر في التنفيذ حتى لو فشل الإشعار
    }
    
    return healthTip.id;
  }
  
  // Update a health tip
  Future<void> updateHealthTip(HealthTipModel healthTip) async {
    await _supabase
        .from(_tableName)
        .update(healthTip.toJson())
        .eq('id', healthTip.id);
  }
  
  // Delete a health tip
  Future<void> deleteHealthTip(String id) async {
    await _supabase
        .from(_tableName)
        .delete()
        .eq('id', id);
  }
  
  // Toggle featured status
  Future<void> toggleFeaturedStatus(String id, bool isFeatured) async {
    await _supabase
        .from(_tableName)
        .update({'is_featured': isFeatured})
        .eq('id', id);
  }
  
  // Generate a unique ID
  String generateUniqueId() {
    return const Uuid().v4();
  }
  
  // Count total health tips
  Future<int> countHealthTips() async {
    final response = await _supabase
        .from(_tableName)
        .select();
    
    // Return the length of the response as the count
    return (response as List).length;
  }
} 