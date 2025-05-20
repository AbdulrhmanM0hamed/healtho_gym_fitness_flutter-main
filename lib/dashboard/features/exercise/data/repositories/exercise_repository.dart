import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/models/exercise_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseRepository {
  final SupabaseClient _supabase = SupabaseService.supabase;
  final String _table = 'exercises';

  // Get exercises by category and level
  Future<List<Exercise>> getExercisesByLevel(int categoryId, int level) async {
    try {
      print('DEBUG REPO: Fetching exercises for category $categoryId and level $level');
      
      var query = _supabase
          .from(_table)
          .select();

      // Apply filters
      if (categoryId > 0) {
        final response = await query
            .eq('category_id', categoryId)
            .eq('level', level)
            .order('created_at', ascending: false);
        
        print('DEBUG REPO: Received ${response.length} exercises');
        print('DEBUG REPO: Exercise data: $response');
        
        return response
            .map<Exercise>((json) => Exercise.fromJson(json))
            .toList();
      } else {
        final response = await query
            .eq('level', level)
            .order('created_at', ascending: false);
        
        print('DEBUG REPO: Received ${response.length} exercises');
        print('DEBUG REPO: Exercise data: $response');
        
        return response
            .map<Exercise>((json) => Exercise.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('DEBUG REPO: Error fetching exercises: $e');
      throw Exception('Failed to load exercises: $e');
    }
  }

  // Add new exercise
  Future<Exercise> addExercise({
    required int categoryId,
    required String title,
    required String description,
    required String mainImageUrl,
    required List<String> imageUrl,
    required int level,
  }) async {
    try {
      print('DEBUG REPO: Adding new exercise');
      final now = DateTime.now();
      
      final response = await _supabase
          .from(_table)
          .insert({
            'category_id': categoryId,
            'title': title,
            'description': description,
            'main_image_url': mainImageUrl,
            'image_url': imageUrl,
            'level': level,
            'is_favorite': false,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();
      
      print('DEBUG REPO: Successfully added exercise: $response');
      return Exercise.fromJson(response);
    } catch (e) {
      print('DEBUG REPO: Error adding exercise: $e');
      throw Exception('Failed to add exercise: $e');
    }
  }

  // Update exercise
  Future<void> updateExercise(Exercise exercise) async {
    try {
      print('DEBUG REPO: Updating exercise ${exercise.id}');
      await _supabase
          .from(_table)
          .update({
            'category_id': exercise.categoryId,
            'title': exercise.title,
            'description': exercise.description,
            'main_image_url': exercise.mainImageUrl,
            'image_url': exercise.imageUrl,
            'level': exercise.level,
            'is_favorite': exercise.isFavorite,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', exercise.id);
      
      print('DEBUG REPO: Successfully updated exercise ${exercise.id}');
    } catch (e) {
      print('DEBUG REPO: Error updating exercise: $e');
      throw Exception('Failed to update exercise: $e');
    }
  }

  // Delete exercise
  Future<void> deleteExercise(int id) async {
    try {
      print('DEBUG REPO: Deleting exercise $id');
      await _supabase
          .from(_table)
          .delete()
          .eq('id', id);
      
      print('DEBUG REPO: Successfully deleted exercise $id');
    } catch (e) {
      print('DEBUG REPO: Error deleting exercise: $e');
      throw Exception('Failed to delete exercise: $e');
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(int exerciseId, bool isFavorite) async {
    try {
      print('DEBUG REPO: Toggling favorite for exercise $exerciseId to $isFavorite');
      await _supabase
          .from(_table)
          .update({'is_favorite': isFavorite})
          .eq('id', exerciseId);
      
      print('DEBUG REPO: Successfully updated favorite status');
    } catch (e) {
      print('DEBUG REPO: Error updating favorite status: $e');
      throw Exception('Failed to update favorite status: $e');
    }
  }
} 