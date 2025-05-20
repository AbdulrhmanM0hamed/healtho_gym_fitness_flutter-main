import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/models/exercise_category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseCategoryRepository {
  final SupabaseClient _supabase = SupabaseService.supabase;
  final String _table = 'exercise_categories';

  // Get all categories
  Future<List<ExerciseCategory>> getCategories() async {
    try {
      print('DEBUG REPO: Fetching all exercise categories');
      final response = await _supabase
          .from(_table)
          .select()
          .order('created_at', ascending: false);
      
      print('DEBUG REPO: Received ${response.length} categories');
      print('DEBUG REPO: Category data: $response');
      
      return response
          .map<ExerciseCategory>((json) => ExerciseCategory.fromJson(json))
          .toList();
    } catch (e) {
      print('DEBUG REPO: Error fetching categories: $e');
      throw Exception('Failed to load exercise categories: $e');
    }
  }

  Future<ExerciseCategory?> getCategory(int id) async {
    try {
      final response = await _supabase
          .from('exercise_categories')
          .select()
          .eq('id', id)
          .single();
      
      return response != null ? ExerciseCategory.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }

  // Add new category
  Future<ExerciseCategory> addCategory({
    required String title,
    required String titleAr,
    required String imageUrl,
  }) async {
    try {
      print('DEBUG REPO: Adding new category');
      final now = DateTime.now();
      
      final response = await _supabase
          .from(_table)
          .insert({
            'title': title,
            'title_ar': titleAr,
            'image_url': imageUrl,
            'exercises_count': 0,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();
      
      print('DEBUG REPO: Successfully added category: $response');
      return ExerciseCategory.fromJson(response);
    } catch (e) {
      print('DEBUG REPO: Error adding category: $e');
      throw Exception('Failed to add exercise category: $e');
    }
  }

  // Update category
  Future<void> updateCategory(ExerciseCategory category) async {
    try {
      print('DEBUG REPO: Updating category ${category.id}');
      await _supabase
          .from(_table)
          .update({
            'title': category.title,
            'title_ar': category.titleAr,
            'image_url': category.imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', category.id);
      
      print('DEBUG REPO: Successfully updated category ${category.id}');
    } catch (e) {
      print('DEBUG REPO: Error updating category: $e');
      throw Exception('Failed to update exercise category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    try {
      print('DEBUG REPO: Deleting category $id');
      await _supabase
          .from(_table)
          .delete()
          .eq('id', id);
      
      print('DEBUG REPO: Successfully deleted category $id');
    } catch (e) {
      print('DEBUG REPO: Error deleting category: $e');
      throw Exception('Failed to delete exercise category: $e');
    }
  }
} 