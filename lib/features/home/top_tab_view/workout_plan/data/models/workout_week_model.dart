import 'package:equatable/equatable.dart';

class WorkoutWeekModel extends Equatable {
  final int id;
  final int planId;
  final int weekNumber;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutWeekModel({
    required this.id,
    required this.planId,
    required this.weekNumber,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutWeekModel.fromJson(Map<String, dynamic> json) {
    return WorkoutWeekModel(
      id: json['id'],
      planId: json['plan_id'],
      weekNumber: json['week_number'],
      title: json['title'] ?? 'Week ${json['week_number']}',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'week_number': weekNumber,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WorkoutWeekModel copyWith({
    int? id,
    int? planId,
    int? weekNumber,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutWeekModel(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      weekNumber: weekNumber ?? this.weekNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    planId,
    weekNumber,
    title,
    description,
    createdAt,
    updatedAt,
  ];
} 