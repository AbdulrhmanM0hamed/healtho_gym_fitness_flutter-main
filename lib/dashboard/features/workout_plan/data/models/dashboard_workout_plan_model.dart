import 'package:equatable/equatable.dart';

/// نموذج خطة التمرين في لوحة التحكم
class DashboardWorkoutPlanModel extends Equatable {
  final int? id;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DashboardWorkoutPlanModel({
    this.id,
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
    this.createdAt,
    this.updatedAt,
  });

  factory DashboardWorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return DashboardWorkoutPlanModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      mainImageUrl: json['main_image_url'],
      goal: json['goal'],
      durationWeeks: json['duration_weeks'],
      level: json['level'],
      daysPerWeek: json['days_per_week'],
      targetGender: json['target_gender'],
      isFeatured: json['is_featured'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
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
    };

    // إضافة المعرف إذا كان موجودًا (للتحديث)
    if (id != null) {
      data['id'] = id;
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
  DashboardWorkoutPlanModel copyWith({
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DashboardWorkoutPlanModel(
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
    createdAt,
    updatedAt,
  ];
}
