import 'package:equatable/equatable.dart';

class WorkoutDayModel extends Equatable {
  final int id;
  final int weekId;
  final String dayName;
  final int dayNumber;
  final bool isRestDay;
  final int totalExercises;
  final int majorExercises;
  final int minorExercises;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutDayModel({
    required this.id,
    required this.weekId,
    required this.dayName,
    required this.dayNumber,
    required this.isRestDay,
    required this.totalExercises,
    required this.majorExercises,
    required this.minorExercises,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutDayModel.fromJson(Map<String, dynamic> json) {
    return WorkoutDayModel(
      id: json['id'],
      weekId: json['week_id'],
      dayName: json['day_name'],
      dayNumber: json['day_number'],
      isRestDay: json['is_rest_day'] ?? false,
      totalExercises: json['total_exercises'] ?? 0,
      majorExercises: json['major_exercises'] ?? 0,
      minorExercises: json['minor_exercises'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'week_id': weekId,
      'day_name': dayName,
      'day_number': dayNumber,
      'is_rest_day': isRestDay,
      'total_exercises': totalExercises,
      'major_exercises': majorExercises,
      'minor_exercises': minorExercises,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WorkoutDayModel copyWith({
    int? id,
    int? weekId,
    String? dayName,
    int? dayNumber,
    bool? isRestDay,
    int? totalExercises,
    int? majorExercises,
    int? minorExercises,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutDayModel(
      id: id ?? this.id,
      weekId: weekId ?? this.weekId,
      dayName: dayName ?? this.dayName,
      dayNumber: dayNumber ?? this.dayNumber,
      isRestDay: isRestDay ?? this.isRestDay,
      totalExercises: totalExercises ?? this.totalExercises,
      majorExercises: majorExercises ?? this.majorExercises,
      minorExercises: minorExercises ?? this.minorExercises,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    weekId,
    dayName,
    dayNumber,
    isRestDay,
    totalExercises,
    majorExercises,
    minorExercises,
    createdAt,
    updatedAt,
  ];
} 