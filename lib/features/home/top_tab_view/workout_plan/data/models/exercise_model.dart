import 'package:equatable/equatable.dart';

/// نموذج التمرين
class ExerciseModel extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? mainImageUrl;
  final String? videoUrl;
  final String? instructions;
  final String? tips;
  final String? targetMuscles;
  final String? equipment;
  final int? categoryId;
  final String? categoryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ExerciseModel({
    required this.id,
    required this.title,
    this.description,
    this.mainImageUrl,
    this.videoUrl,
    this.instructions,
    this.tips,
    this.targetMuscles,
    this.equipment,
    this.categoryId,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      mainImageUrl: json['main_image_url'] ?? json['image_url'],
      videoUrl: json['video_url'],
      instructions: json['instructions'],
      tips: json['tips'],
      targetMuscles: json['target_muscles'],
      equipment: json['equipment'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
    };

    if (description != null) data['description'] = description;
    if (mainImageUrl != null) data['main_image_url'] = mainImageUrl;
    if (videoUrl != null) data['video_url'] = videoUrl;
    if (instructions != null) data['instructions'] = instructions;
    if (tips != null) data['tips'] = tips;
    if (targetMuscles != null) data['target_muscles'] = targetMuscles;
    if (equipment != null) data['equipment'] = equipment;
    if (categoryId != null) data['category_id'] = categoryId;
    if (categoryName != null) data['category_name'] = categoryName;
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        mainImageUrl,
        videoUrl,
        instructions,
        tips,
        targetMuscles,
        equipment,
        categoryId,
        categoryName,
        createdAt,
        updatedAt,
      ];
}
