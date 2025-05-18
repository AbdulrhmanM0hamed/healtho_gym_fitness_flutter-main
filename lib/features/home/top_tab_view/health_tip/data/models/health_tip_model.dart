class HealthTipModel {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final List<String>? tags;
  final int? likes;
  final bool isFeatured;

  HealthTipModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.tags,
    this.likes = 0,
    this.isFeatured = false,
  });

  factory HealthTipModel.fromJson(Map<String, dynamic> json) {
    return HealthTipModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List)
          : null,
      likes: json['likes'] as int?,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'tags': tags,
      'likes': likes,
      'is_featured': isFeatured,
    };
  }
  
  // For local usage when no id is generated yet
  factory HealthTipModel.empty() => HealthTipModel(
    id: '',
    title: '',
    subtitle: '',
    content: '',
    createdAt: DateTime.now(),
  );

  HealthTipModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? tags,
    int? likes,
    bool? isFeatured,
  }) {
    return HealthTipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
} 