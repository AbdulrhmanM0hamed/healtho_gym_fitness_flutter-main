import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/exercise_model.dart';

/// نموذج تمرين اليوم في لوحة التحكم
class DashboardDayExerciseModel extends Equatable {
  final int? id;
  final int? dayId;
  final int exerciseId;
  final int sets;
  final int reps;
  final int restTime;
  final double? weight;
  final String? notes;
  final int sortOrder;
  final String exerciseName;
  final String exerciseImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ExerciseModel? exerciseDetails;

  const DashboardDayExerciseModel({
    this.id,
    this.dayId,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.restTime,
    this.weight,
    this.notes,
    required this.sortOrder,
    required this.exerciseName,
    required this.exerciseImage,
    this.createdAt,
    this.updatedAt,
    this.exerciseDetails,
  });

  factory DashboardDayExerciseModel.fromJson(Map<String, dynamic> json) {
    // استخراج اسم التمرين وصورته من كائن التمارين المتداخل إذا كان متاحًا
    String exerciseName = '';
    String exerciseImage = '';
    
    if (json.containsKey('exercises') && json['exercises'] != null) {
      final exercises = json['exercises'] as Map<String, dynamic>;
      exerciseName = exercises['title'] ?? '';
      
      // محاولة استخدام image_url إذا كان متاحًا، وإلا استخدام main_image_url
      if (exercises.containsKey('image_url')) {
        exerciseImage = exercises['image_url'] ?? '';
      } else if (exercises.containsKey('main_image_url')) {
        exerciseImage = exercises['main_image_url'] ?? '';
      }
    } else {
      exerciseName = json['exercise_name'] ?? '';
      exerciseImage = json['exercise_image'] ?? '';
    }
    
    // إنشاء كائن التمرين إذا كانت البيانات متوفرة
    ExerciseModel? exerciseDetails;
    if (json.containsKey('exercises') && json['exercises'] != null) {
      exerciseDetails = ExerciseModel.fromJson(json['exercises']);
    }
    
    return DashboardDayExerciseModel(
      id: json['id'],
      dayId: json['day_id'],
      exerciseId: json['exercise_id'],
      sets: json['sets'] is int ? json['sets'] : int.tryParse(json['sets']?.toString() ?? '3') ?? 3,
      reps: json['reps'] is int ? json['reps'] : int.tryParse(json['reps']?.toString() ?? '12') ?? 12,
      restTime: json['rest_time'] is int ? json['rest_time'] : int.tryParse(json['rest_time']?.toString() ?? '60') ?? 60,
      weight: json['weight'] is double ? json['weight'] : double.tryParse(json['weight']?.toString() ?? '0') ?? 0,
      notes: json['notes'],
      sortOrder: json['sort_order'] is int ? json['sort_order'] : int.tryParse(json['sort_order']?.toString() ?? '1') ?? 1,
      exerciseName: exerciseName,
      exerciseImage: exerciseImage,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      exerciseDetails: exerciseDetails,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'rest_time': restTime,
      'sort_order': sortOrder,
      'exercise_name': exerciseName,
      'exercise_image': exerciseImage,
    };

    // إضافة المعرف إذا كان موجودًا (للتحديث)
    if (id != null) {
      data['id'] = id;
    }

    // إضافة معرف اليوم إذا كان موجودًا
    if (dayId != null) {
      data['day_id'] = dayId;
    }
    
    // إضافة الوزن والملاحظات إذا كانت موجودة
    if (weight != null) {
      data['weight'] = weight;
    }
    if (notes != null) {
      data['notes'] = notes;
    }

    // إضافة تواريخ الإنشاء والتحديث إذا كانت موجودة
    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toIso8601String();
    }

    return data;
  }

  /// إنشاء نسخة جديدة مع تحديث بعض الحقول
  DashboardDayExerciseModel copyWith({
    int? id,
    int? dayId,
    int? exerciseId,
    int? sets,
    int? reps,
    int? restTime,
    double? weight,
    String? notes,
    int? sortOrder,
    String? exerciseName,
    String? exerciseImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    ExerciseModel? exerciseDetails,
  }) {
    return DashboardDayExerciseModel(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseImage: exerciseImage ?? this.exerciseImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      exerciseDetails: exerciseDetails ?? this.exerciseDetails,
    );
  }

  @override
  List<Object?> get props => [
    id,
    dayId,
    exerciseId,
    sets,
    reps,
    restTime,
    weight,
    notes,
    sortOrder,
    exerciseName,
    exerciseImage,
    createdAt,
    updatedAt,
    exerciseDetails,
  ];
}
