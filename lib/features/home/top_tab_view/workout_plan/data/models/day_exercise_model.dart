import 'package:equatable/equatable.dart';

class DayExerciseModel extends Equatable {
  final int id;
  final int dayId;
  final int exerciseId;
  final int sets;
  final String reps;
  final String restTime;
  final int sortOrder;
  final bool isCompleted;
  final String exerciseName;
  final String exerciseImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DayExerciseModel({
    required this.id,
    required this.dayId,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.restTime,
    required this.sortOrder,
    this.isCompleted = false,
    required this.exerciseName,
    required this.exerciseImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DayExerciseModel.fromJson(Map<String, dynamic> json) {
    // Extract exercise name and image from nested exercises object if available
    String exerciseName = '';
    String exerciseImage = '';
    
    if (json.containsKey('exercises') && json['exercises'] != null) {
      final exercises = json['exercises'] as Map<String, dynamic>;
      exerciseName = exercises['title'] ?? '';
      
      // Try to use image_url if available, otherwise fall back to main_image_url
      if (exercises.containsKey('image_url')) {
        exerciseImage = exercises['image_url'] ?? '';
      } else if (exercises.containsKey('main_image_url')) {
        exerciseImage = exercises['main_image_url'] ?? '';
      }
    } else {
      exerciseName = json['exercise_name'] ?? '';
      exerciseImage = json['exercise_image'] ?? '';
    }
    
    return DayExerciseModel(
      id: json['id'],
      dayId: json['day_id'],
      exerciseId: json['exercise_id'],
      sets: json['sets'],
      reps: json['reps'],
      restTime: json['rest_time'],
      sortOrder: json['sort_order'],
      isCompleted: json['is_completed'] ?? false,
      exerciseName: exerciseName,
      exerciseImage: exerciseImage,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_id': dayId,
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'rest_time': restTime,
      'sort_order': sortOrder,
      'is_completed': isCompleted,
      'exercise_name': exerciseName,
      'exercise_image': exerciseImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DayExerciseModel copyWith({
    int? id,
    int? dayId,
    int? exerciseId,
    int? sets,
    String? reps,
    String? restTime,
    int? sortOrder,
    bool? isCompleted,
    String? exerciseName,
    String? exerciseImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DayExerciseModel(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
      sortOrder: sortOrder ?? this.sortOrder,
      isCompleted: isCompleted ?? this.isCompleted,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseImage: exerciseImage ?? this.exerciseImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    sortOrder,
    isCompleted,
    exerciseName,
    exerciseImage,
    createdAt,
    updatedAt,
  ];
} 