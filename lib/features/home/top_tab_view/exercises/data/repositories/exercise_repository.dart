import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseRepository {
  final SupabaseClient _supabase = SupabaseService.supabase;

  // الحصول على كل فئات التمارين
  Future<List<ExerciseCategory>> getExerciseCategories() async {
    try {
      print('DEBUG REPO: Fetching all exercise categories');
      final response = await _supabase
          .from('exercise_categories')
          .select()
          .order('id');
      
      print('DEBUG REPO: Received ${response.length} categories');
      print('DEBUG REPO: Category data: $response');
      
      return response
          .map<ExerciseCategory>((json) => ExerciseCategory.fromJson(json))
          .toList();
    } catch (e) {
      print('DEBUG REPO: Error fetching categories: $e');
      throw Exception('فشل في تحميل فئات التمارين: $e');
    }
  }

  // الحصول على التمارين حسب الفئة
  Future<List<Exercise>> getExercisesByCategory(int categoryId) async {
    try {
      print('DEBUG REPO: Fetching exercises for category $categoryId');
      final response = await _supabase
          .from('exercises')
          .select()
          .eq('category_id', categoryId)
          .order('id');
      
      print('DEBUG REPO: Received ${response.length} exercises for category $categoryId');
      print('DEBUG REPO: Exercise data: $response');
      
      return response
          .map<Exercise>((json) => Exercise.fromJson(json))
          .toList();
    } catch (e) {
      print('DEBUG REPO: Error fetching exercises: $e');
      throw Exception('فشل في تحميل التمارين: $e');
    }
  }

  // الحصول على التمارين حسب المستوى
  Future<List<Exercise>> getExercisesByLevel(int categoryId, int level) async {
    try {
      print('DEBUG REPO: Fetching exercises for category $categoryId and level $level');
      final response = await _supabase
          .from('exercises')
          .select()
          .eq('category_id', categoryId)
          .eq('level', level)
          .order('id');
      
      print('DEBUG REPO: Received ${response.length} exercises for category $categoryId and level $level');
      print('DEBUG REPO: Exercise data: $response');
      
      return response
          .map<Exercise>((json) => Exercise.fromJson(json))
          .toList();
    } catch (e) {
      print('DEBUG REPO: Error fetching exercises by level: $e');
      throw Exception('فشل في تحميل التمارين حسب المستوى: $e');
    }
  }

  // تبديل حالة المفضلة
  Future<void> toggleFavorite(int exerciseId, bool isFavorite) async {
    try {
      print('DEBUG REPO: Toggling favorite for exercise $exerciseId to $isFavorite');
      await _supabase
          .from('exercises')
          .update({'is_favorite': isFavorite})
          .eq('id', exerciseId);
      print('DEBUG REPO: Successfully updated favorite status');
    } catch (e) {
      print('DEBUG REPO: Error updating favorite status: $e');
      throw Exception('فشل في تحديث حالة المفضلة: $e');
    }
  }
} 