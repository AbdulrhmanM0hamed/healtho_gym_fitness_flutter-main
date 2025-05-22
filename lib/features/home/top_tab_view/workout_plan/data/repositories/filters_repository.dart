import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class FiltersRepository {
  final SupabaseClient _supabase;

  FiltersRepository(this._supabase);

  // Get categories from database
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _supabase
        .from('workout_categories')
        .select();

      return List<Map<String, dynamic>>.from(response)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
    } catch (e) {
      // Fallback to default values in case of error
      return [
        CategoryModel(id: 1, name: 'زيادة الكتلة العضلية'),
        CategoryModel(id: 2, name: 'خسارة الوزن'),
        CategoryModel(id: 3, name: 'لياقة عامة'),
      ];
    }
  }

  // Get goals from database or return default
  Future<List<String>> getGoals() async {
    try {
      // In a real app, this would be fetched from an API or database
      final response = await _supabase
        .from('workout_goals')
        .select('name');

      return List<Map<String, dynamic>>.from(response)
        .map((json) => json['name'] as String)
        .toList();
    } catch (e) {
      // Fallback to default values
      return ['Weight Loss', 'Muscle Building', 'Strength', 'Endurance'];
    }
  }

  // Get levels from database or return default
  Future<List<String>> getLevels() async {
    try {
      // In a real app, this would be fetched from an API or database
      final response = await _supabase
        .from('workout_levels')
        .select('name');

      return List<Map<String, dynamic>>.from(response)
        .map((json) => json['name'] as String)
        .toList();
    } catch (e) {
      // Fallback to default values
      return ['Beginner', 'Intermediate', 'Advanced'];
    }
  }

  // Get durations from database or return default
  Future<List<String>> getDurations() async {
    try {
      // In a real app, this would be fetched from an API or database
      final response = await _supabase
        .from('workout_durations')
        .select('name');

      return List<Map<String, dynamic>>.from(response)
        .map((json) => json['name'] as String)
        .toList();
    } catch (e) {
      // Fallback to default values
      return ['4 Weeks', '8 Weeks', '12 Weeks'];
    }
  }
} 