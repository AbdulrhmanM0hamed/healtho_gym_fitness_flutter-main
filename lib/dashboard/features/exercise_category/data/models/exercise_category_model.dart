class ExerciseCategory {
  final int id;
  final String title;
  final String titleAr;
  final String imageUrl;
  final int exercisesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExerciseCategory({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.imageUrl,
    required this.exercisesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExerciseCategory.fromJson(Map<String, dynamic> json) {
    return ExerciseCategory(
      id: json['id'],
      title: json['title'],
      titleAr: json['title_ar'],
      imageUrl: json['image_url'],
      exercisesCount: json['exercises_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'image_url': imageUrl,
      'exercises_count': exercisesCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ExerciseCategory copyWith({
    int? id,
    String? title,
    String? titleAr,
    String? imageUrl,
    int? exercisesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExerciseCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      imageUrl: imageUrl ?? this.imageUrl,
      exercisesCount: exercisesCount ?? this.exercisesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 