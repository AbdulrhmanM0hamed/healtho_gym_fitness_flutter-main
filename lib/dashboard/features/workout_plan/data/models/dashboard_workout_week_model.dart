import 'package:equatable/equatable.dart';

/// نموذج أسبوع التمرين في لوحة التحكم
class DashboardWorkoutWeekModel extends Equatable {
  final int? id;
  final int? planId;
  final int weekNumber;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DashboardWorkoutWeekModel({
    this.id,
    this.planId,
    required this.weekNumber,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory DashboardWorkoutWeekModel.fromJson(Map<String, dynamic> json) {
    return DashboardWorkoutWeekModel(
      id: json['id'],
      planId: json['plan_id'],
      weekNumber: json['week_number'],
      title: json['title'] ?? 'Week ${json['week_number']}',
      description: json['description'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'week_number': weekNumber,
      'title': title,
      'description': description,
    };

    // إضافة المعرف إذا كان موجودًا (للتحديث)
    if (id != null) {
      data['id'] = id;
    }

    // إضافة معرف الخطة إذا كان موجودًا
    if (planId != null) {
      data['plan_id'] = planId;
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
  DashboardWorkoutWeekModel copyWith({
    int? id,
    int? planId,
    int? weekNumber,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DashboardWorkoutWeekModel(
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
