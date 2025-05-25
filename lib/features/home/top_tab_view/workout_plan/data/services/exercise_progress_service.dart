import 'package:shared_preferences/shared_preferences.dart';

/// خدمة لتتبع تقدم التمارين وحفظ حالة الإكمال والأوزان والأوزان) باستخدام SharedPreferences
class ExerciseProgressService {
  static const String _completedExercisesKey = 'completed_exercises';
  static const String _exerciseWeightsPrefix = 'exercise_weight_';

  /// تسجيل تمرين كمكتتم
  static Future<void> markExerciseCompleted(int exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedExercises = await getCompletedExercises();
    
    if (!completedExercises.contains(exerciseId)) {
      completedExercises.add(exerciseId);
      await prefs.setStringList(
        _completedExercisesKey,
        completedExercises.map((id) => id.toString()).toList(),
      );
    }
  }

  /// إلغاء تسجيل تمرين كمكتمل
  static Future<void> markExerciseIncomplete(int exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedExercises = await getCompletedExercises();
    
    if (completedExercises.contains(exerciseId)) {
      completedExercises.remove(exerciseId);
      await prefs.setStringList(
        _completedExercisesKey,
        completedExercises.map((id) => id.toString()).toList(),
      );
    }
  }

  /// الحصول على قائمة التمارين المكتملة
  static Future<List<int>> getCompletedExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final completedExercisesStr = prefs.getStringList(_completedExercisesKey) ?? [];
    
    return completedExercisesStr
        .map((idStr) => int.tryParse(idStr) ?? 0)
        .where((id) => id > 0)
        .toList();
  }

  /// التحقق مما إذا كان التمرين مكتملاً
  static Future<bool> isExerciseCompleted(int exerciseId) async {
    final completedExercises = await getCompletedExercises();
    return completedExercises.contains(exerciseId);
  }

  /// إعادة تعيين جميع التمارين المكتملة
  static Future<void> resetAllCompletedExercises() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedExercisesKey);
  }

  /// حفظ وزن جديد لتمرين
  static Future<void> saveExerciseWeight(int exerciseId, double weight) async {
    final prefs = await SharedPreferences.getInstance();
    
    // احفظ الوزن الحالي كوزن سابق
    final currentWeight = await getExerciseWeight(exerciseId);
    if (currentWeight > 0) {
      await prefs.setDouble('${_exerciseWeightsPrefix}${exerciseId}_previous', currentWeight);
    }
    
    // احفظ الوزن الجديد
    await prefs.setDouble('${_exerciseWeightsPrefix}$exerciseId', weight);
  }

  /// الحصول على الوزن الحالي للتمرين
  static Future<double> getExerciseWeight(int exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${_exerciseWeightsPrefix}$exerciseId') ?? 0.0;
  }

  /// الحصول على الوزن السابق للتمرين
  static Future<double> getPreviousExerciseWeight(int exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${_exerciseWeightsPrefix}${exerciseId}_previous') ?? 0.0;
  }
}
