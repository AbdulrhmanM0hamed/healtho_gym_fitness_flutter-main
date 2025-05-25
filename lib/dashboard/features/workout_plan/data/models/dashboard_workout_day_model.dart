import 'package:equatable/equatable.dart';

/// نموذج يوم التمرين في لوحة التحكم
class DashboardWorkoutDayModel extends Equatable {
  final int? id;
  final int? weekId;
  final String dayName;
  final int dayNumber;
  final bool isRestDay;
  final int totalExercises;
  final int majorExercises;
  final int minorExercises;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DashboardWorkoutDayModel({
    this.id,
    this.weekId,
    required this.dayName,
    required this.dayNumber,
    required this.isRestDay,
    this.totalExercises = 0,
    this.majorExercises = 0,
    this.minorExercises = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory DashboardWorkoutDayModel.fromJson(Map<String, dynamic> json) {
    return DashboardWorkoutDayModel(
      id: json['id'],
      weekId: json['week_id'],
      dayName: json['day_name'],
      dayNumber: json['day_number'],
      isRestDay: json['is_rest_day'] ?? false,
      totalExercises: json['total_exercises'] ?? 0,
      majorExercises: json['major_exercises'] ?? 0,
      minorExercises: json['minor_exercises'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'day_name': dayName,
      'day_number': dayNumber,
      'is_rest_day': isRestDay,
      'total_exercises': totalExercises,
      'major_exercises': majorExercises,
      'minor_exercises': minorExercises,
    };

    // إضافة المعرف إذا كان موجودًا (للتحديث)
    if (id != null) {
      data['id'] = id;
    }

    // إضافة معرف الأسبوع إذا كان موجودًا
    if (weekId != null) {
      data['week_id'] = weekId;
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
  DashboardWorkoutDayModel copyWith({
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
    return DashboardWorkoutDayModel(
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
