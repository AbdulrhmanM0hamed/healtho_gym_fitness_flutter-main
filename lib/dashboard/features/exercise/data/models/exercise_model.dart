import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final String mainImageUrl;
  final List<String> imageUrl;
  final int level;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exercise({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.mainImageUrl,
    required this.level,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    List<String> parseImageUrl(dynamic imageUrlData) {
      if (imageUrlData == null) return [];
      if (imageUrlData is List) return List<String>.from(imageUrlData);
      if (imageUrlData is String) {
        try {
          // Remove all backslashes, brackets, and quotes, then split by comma
          final cleanString = imageUrlData
              .replaceAll('\\', '')
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll('"', '')
              .trim();
          return cleanString.split(',')
              .map((url) => url.trim())
              .where((url) => url.isNotEmpty)
              .toList();
        } catch (e) {
          print('Error parsing image URLs: $e');
          return [];
        }
      }
      return [];
    }

    return Exercise(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      mainImageUrl: json['main_image_url'],
      level: json['level'],
      isFavorite: json['is_favorite'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      imageUrl: parseImageUrl(json['image_url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'main_image_url': mainImageUrl,
      'level': level,
      'is_favorite': isFavorite,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }

  Exercise copyWith({
    int? id,
    int? categoryId,
    String? title,
    String? description,
    String? mainImageUrl,
    List<String>? imageUrl,
    int? level,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      level: level ?? this.level,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        categoryId,
        title,
        description,
        mainImageUrl,
        imageUrl,
        level,
        isFavorite,
        createdAt,
        updatedAt,
      ];
} 