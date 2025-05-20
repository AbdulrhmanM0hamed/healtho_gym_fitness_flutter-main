import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:healtho_gym/core/services/supabase_service.dart';

class StorageService {
  final SupabaseClient _supabase = SupabaseService.supabase;
  final _uuid = const Uuid();

  // Constants for bucket names
  static const String exerciseCategoriesBucket = 'exercise-categories';
  static const String exercisesBucket = 'exercises';

  // Upload category image
  Future<String> uploadCategoryImage(File imageFile) async {
    try {
      final fileExt = path.extension(imageFile.path);
      final fileName = '${_uuid.v4()}$fileExt';

      await _supabase.storage
          .from(exerciseCategoriesBucket)
          .upload(fileName, imageFile);
      
      final imageUrl = _supabase.storage
          .from(exerciseCategoriesBucket)
          .getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload category image: $e');
    }
  }

  // Upload exercise main image
  Future<String> uploadExerciseMainImage(File imageFile, int categoryId) async {
    try {
      final fileExt = path.extension(imageFile.path);
      final fileName = '${_uuid.v4()}$fileExt';
      final filePath = '$categoryId/main/$fileName';

      await _supabase.storage
          .from(exercisesBucket)
          .upload(filePath, imageFile);
      
      final imageUrl = _supabase.storage
          .from(exercisesBucket)
          .getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload exercise main image: $e');
    }
  }

  // Upload exercise gallery images
  Future<List<String>> uploadExerciseGalleryImages(List<File> imageFiles, int categoryId) async {
    try {
      final urls = <String>[];
      for (final imageFile in imageFiles) {
        final fileExt = path.extension(imageFile.path);
        final fileName = '${_uuid.v4()}$fileExt';
        final filePath = '$categoryId/gallery/$fileName';

        await _supabase.storage
            .from(exercisesBucket)
            .upload(filePath, imageFile);
        
        final imageUrl = _supabase.storage
            .from(exercisesBucket)
            .getPublicUrl(filePath);
        urls.add(imageUrl);
      }
      return urls;
    } catch (e) {
      throw Exception('Failed to upload exercise gallery images: $e');
    }
  }

  // Delete category image
  Future<void> deleteCategoryImage(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final fileName = pathSegments.last;
      
      await _supabase.storage
          .from(exerciseCategoriesBucket)
          .remove([fileName]);
    } catch (e) {
      throw Exception('Failed to delete category image: $e');
    }
  }

  // Delete exercise image
  Future<void> deleteExerciseImage(String imageUrl) async {
    try {
      if (imageUrl.startsWith('[') && imageUrl.endsWith(']')) {
        // If imageUrl is a JSON array string, parse it and delete each URL
        final List<dynamic> urls = Uri.encodeFull(imageUrl).split(',');
        for (final url in urls) {
          await _deleteExerciseImageUrl(url.toString().replaceAll('[', '').replaceAll(']', '').trim());
        }
      } else {
        await _deleteExerciseImageUrl(imageUrl);
      }
    } catch (e) {
      throw Exception('Failed to delete exercise image: $e');
    }
  }

  // Helper method to delete a single image URL
  Future<void> _deleteExerciseImageUrl(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final filePath = pathSegments
          .sublist(pathSegments.indexOf(exercisesBucket) + 1)
          .join('/');
      
      await _supabase.storage
          .from(exercisesBucket)
          .remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete exercise image: $e');
    }
  }

  // Delete multiple exercise images
  Future<void> deleteExerciseImages(List<String> imageUrls) async {
    try {
      for (final url in imageUrls) {
        await _deleteExerciseImageUrl(url);
      }
    } catch (e) {
      throw Exception('Failed to delete exercise images: $e');
    }
  }
} 