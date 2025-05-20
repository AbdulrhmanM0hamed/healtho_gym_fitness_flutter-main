import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthTipStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _bucketName = 'healthtip';
  
  // Upload image file and return public URL
  Future<String?> uploadImage(XFile pickedFile, String fileName) async {
    try {
      String finalFileName = fileName;
      if (!finalFileName.contains('.')) {
        // Add extension if missing
        final extension = _getFileExtension(pickedFile);
        finalFileName = '$fileName.$extension';
      }
      
      if (kIsWeb) {
        // Web platform
        final bytes = await pickedFile.readAsBytes();
        final fileBytes = bytes.buffer.asUint8List();
        
        // Get mime type
        final mimeType = pickedFile.mimeType ?? 'image/jpeg';
        
        await _supabase.storage.from(_bucketName).uploadBinary(
          finalFileName,
          fileBytes,
          fileOptions: FileOptions(
            contentType: mimeType,
            upsert: true
          )
        );
      } else {
        // Mobile platform
        final file = io.File(pickedFile.path);
        await _supabase.storage.from(_bucketName).upload(
          finalFileName,
          file,
          fileOptions: const FileOptions(
            upsert: true
          )
        );
      }
      
      // Get public URL
      final imageUrl = _supabase.storage.from(_bucketName).getPublicUrl(finalFileName);
      return imageUrl;
    } catch (e) {
      print('Storage service error: $e');
      return null;
    }
  }
  
  // Delete image from storage
  Future<bool> deleteImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) return true;
      
      // Extract file name from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isEmpty) return false;
      
      final fileName = pathSegments.last;
      
      await _supabase.storage.from(_bucketName).remove([fileName]);
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }
  
  // Get appropriate file extension
  String _getFileExtension(XFile file) {
    // Try to get extension from mime type first
    if (file.mimeType != null) {
      final mimeType = file.mimeType!;
      if (mimeType.startsWith('image/')) {
        final ext = mimeType.split('/').last;
        // Convert jpeg to jpg for consistency
        if (ext == 'jpeg') return 'jpg';
        return ext;
      }
    }
    
    // Fall back to path extension
    final path = file.path;
    if (path.contains('.')) {
      final ext = path.split('.').last;
      // Sanitize extension from web paths that might contain query params
      if (ext.contains('?')) {
        return ext.split('?').first;
      }
      return ext;
    }
    
    // Default extension
    return 'jpg';
  }
} 