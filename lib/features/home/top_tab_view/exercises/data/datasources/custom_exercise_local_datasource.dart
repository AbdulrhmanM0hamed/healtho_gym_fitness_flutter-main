import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/custom_exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';

/// مصدر بيانات محلي للتمارين المخصصة
class CustomExerciseLocalDataSource {
  static const String _boxName = 'custom_exercises';
  
  // الحصول على صندوق Hive
  Future<Box<Map>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      final appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path);
    }
    return await Hive.openBox<Map>(_boxName);
  }
  
  /// حفظ تمرين مخصص
  Future<void> saveCustomExercise(CustomExercise exercise) async {
    final box = await _getBox();
    await box.put(exercise.id, exercise.toJson());
  }
  
  /// حذف تمرين مخصص
  Future<void> deleteCustomExercise(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
  
  /// الحصول على جميع التمارين المخصصة
  Future<List<CustomExercise>> getAllCustomExercises() async {
    final box = await _getBox();
    return box.values
        .map((e) => CustomExercise.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
  
  /// الحصول على التمارين المخصصة حسب الفئة والمستوى
  Future<List<CustomExercise>> getCustomExercisesByCategoryAndLevel(
      int categoryId, int level) async {
    final box = await _getBox();
    return box.values
        .map((e) => CustomExercise.fromJson(Map<String, dynamic>.from(e as Map)))
        .where((exercise) => 
            exercise.categoryId == categoryId && 
            exercise.level == level)
        .toList();
  }
  
  /// الحصول على تمرين مخصص بواسطة المعرف
  Future<CustomExercise?> getCustomExerciseById(String id) async {
    final box = await _getBox();
    final data = box.get(id);
    if (data == null) return null;
    return CustomExercise.fromJson(Map<String, dynamic>.from(data as Map));
  }
  
  /// الحصول على تمرين مخصص بواسطة معرف التمرين الأصلي
  Future<CustomExercise?> getCustomExerciseByOriginalId(int originalId) async {
    final exercises = await getAllCustomExercises();
    try {
      return exercises.firstWhere((e) => e.originalExerciseId == originalId);
    } catch (e) {
      return null;
    }
  }
  
  /// حفظ صورة محلية للتمرين
  Future<String> saveExerciseImage(XFile imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'exercise_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = File(path.join(appDir.path, fileName));
    
    // نسخ الصورة إلى مجلد التطبيق
    await File(imageFile.path).copy(savedImage.path);
    
    return savedImage.path;
  }
  
  /// حذف صورة محلية
  Future<void> deleteExerciseImage(String imagePath) async {
    if (imagePath.isEmpty) return;
    
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
