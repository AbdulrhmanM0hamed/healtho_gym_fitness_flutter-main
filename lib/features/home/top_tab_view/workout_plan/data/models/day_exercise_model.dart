import 'package:equatable/equatable.dart';

class DayExerciseModel extends Equatable {
  final int id;
  final int dayId;
  final int exerciseId;
  final int sets;
  final String reps;
  final String restTime;
  final int sortOrder;
  final bool isCompleted;
  final String exerciseName;
  final String exerciseImage;
  final String exerciseDescription;
  final int exerciseLevel;
  final List<String> exerciseGalleryImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DayExerciseModel({
    required this.id,
    required this.dayId,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.restTime,
    required this.sortOrder,
    this.isCompleted = false,
    required this.exerciseName,
    required this.exerciseImage,
    this.exerciseDescription = '',
    this.exerciseLevel = 1,
    this.exerciseGalleryImages = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory DayExerciseModel.fromJson(Map<String, dynamic> json) {
    // Extract exercise name, image, description, level, and gallery images from nested exercises object if available
    String exerciseName = '';
    String exerciseImage = '';
    String exerciseDescription = '';
    int exerciseLevel = 1;
    List<String> galleryImages = [];
    
    if (json.containsKey('exercises') && json['exercises'] != null) {
      final exercises = json['exercises'] as Map<String, dynamic>;
      exerciseName = exercises['title'] ?? '';
      exerciseDescription = exercises['description'] ?? '';
      exerciseLevel = exercises['level'] ?? 1;
      
      // Get main image URL
      if (exercises.containsKey('main_image_url')) {
        exerciseImage = exercises['main_image_url'] ?? '';
      }
      
      // Process gallery images (image_url)
      if (exercises.containsKey('image_url')) {
        var imageUrlData = exercises['image_url'];
        
        // If it's already a List<dynamic>, convert it to List<String>
        if (imageUrlData is List) {
          galleryImages = imageUrlData.map((item) => item.toString()).toList();
        }
        // If it's a String, try to parse it
        else if (imageUrlData is String) {
          try {
            // If empty, leave as empty list
            if (imageUrlData.isNotEmpty) {
              // Remove all backslashes, brackets, and quotes, then split by comma
              final cleanString = imageUrlData
                  .replaceAll('\\', '')
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .replaceAll('"', '')
                  .trim();
                  
              galleryImages = cleanString.split(',')
                  .map((url) => url.trim())
                  .where((url) => url.isNotEmpty)
                  .toList();
            }
          } catch (e) {
            print('Error parsing gallery image URLs: $e');
          }
        }
      }
    } else {
      exerciseName = json['exercise_name'] ?? '';
      exerciseImage = json['exercise_image'] ?? '';
      exerciseDescription = json['exercise_description'] ?? '';
      exerciseLevel = json['exercise_level'] ?? 1;
    }
    
    return DayExerciseModel(
      id: json['id'],
      dayId: json['day_id'],
      exerciseId: json['exercise_id'],
      sets: json['sets'],
      reps: json['reps'],
      restTime: json['rest_time'],
      sortOrder: json['sort_order'],
      isCompleted: json['is_completed'] ?? false,
      exerciseName: exerciseName,
      exerciseImage: exerciseImage,
      exerciseDescription: exerciseDescription,
      exerciseLevel: exerciseLevel,
      exerciseGalleryImages: galleryImages,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_id': dayId,
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'rest_time': restTime,
      'sort_order': sortOrder,
      'is_completed': isCompleted,
      'exercise_name': exerciseName,
      'exercise_image': exerciseImage,
      'exercise_description': exerciseDescription,
      'exercise_level': exerciseLevel,
      'exercise_gallery_images': exerciseGalleryImages,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DayExerciseModel copyWith({
    int? id,
    int? dayId,
    int? exerciseId,
    int? sets,
    String? reps,
    String? restTime,
    int? sortOrder,
    bool? isCompleted,
    String? exerciseName,
    String? exerciseImage,
    String? exerciseDescription,
    int? exerciseLevel,
    List<String>? exerciseGalleryImages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DayExerciseModel(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
      sortOrder: sortOrder ?? this.sortOrder,
      isCompleted: isCompleted ?? this.isCompleted,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseImage: exerciseImage ?? this.exerciseImage,
      exerciseDescription: exerciseDescription ?? this.exerciseDescription,
      exerciseLevel: exerciseLevel ?? this.exerciseLevel,
      exerciseGalleryImages: exerciseGalleryImages ?? this.exerciseGalleryImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    dayId,
    exerciseId,
    sets,
    reps,
    restTime,
    sortOrder,
    isCompleted,
    exerciseName,
    exerciseImage,
    exerciseDescription,
    exerciseLevel,
    exerciseGalleryImages,
    createdAt,
    updatedAt,
  ];
}