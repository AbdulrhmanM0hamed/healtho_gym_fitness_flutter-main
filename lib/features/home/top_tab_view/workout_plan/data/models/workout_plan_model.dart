import 'package:equatable/equatable.dart';

class WorkoutPlanModel extends Equatable {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final String mainImageUrl;
  final String goal;
  final int durationWeeks;
  final String level;
  final int daysPerWeek;
  final String targetGender;
  final bool isFeatured;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutPlanModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.mainImageUrl,
    required this.goal,
    required this.durationWeeks,
    required this.level,
    required this.daysPerWeek,
    required this.targetGender,
    required this.isFeatured,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'] ?? '',
      mainImageUrl: json['main_image_url'] ?? '',
      goal: json['goal'],
      durationWeeks: json['duration_weeks'],
      level: json['level'],
      daysPerWeek: json['days_per_week'],
      targetGender: json['target_gender'] ?? 'Both',
      isFeatured: json['is_featured'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'main_image_url': mainImageUrl,
      'goal': goal,
      'duration_weeks': durationWeeks,
      'level': level,
      'days_per_week': daysPerWeek,
      'target_gender': targetGender,
      'is_featured': isFeatured,
      'is_favorite': isFavorite,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WorkoutPlanModel copyWith({
    int? id,
    int? categoryId,
    String? title,
    String? description,
    String? mainImageUrl,
    String? goal,
    int? durationWeeks,
    String? level,
    int? daysPerWeek,
    String? targetGender,
    bool? isFeatured,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutPlanModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      goal: goal ?? this.goal,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      level: level ?? this.level,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      targetGender: targetGender ?? this.targetGender,
      isFeatured: isFeatured ?? this.isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id, 
    categoryId, 
    title, 
    description, 
    mainImageUrl, 
    goal, 
    durationWeeks, 
    level, 
    daysPerWeek, 
    targetGender, 
    isFeatured, 
    isFavorite, 
    createdAt, 
    updatedAt
  ];
} 