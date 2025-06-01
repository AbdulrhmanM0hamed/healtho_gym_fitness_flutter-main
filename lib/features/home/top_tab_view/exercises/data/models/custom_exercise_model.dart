import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';

/// نموذج للتمارين المخصصة التي يتم تخزينها محلياً
class CustomExercise extends Equatable {
  final String id; // معرف فريد للتمرين المخصص
  final int originalExerciseId; // معرف التمرين الأصلي إذا كان مبنياً على تمرين موجود
  final int categoryId; // معرف الفئة
  final String title; // عنوان التمرين
  final String description; // وصف التمرين
  final String mainImageUrl; // رابط الصورة الرئيسية
  final List<String> imageUrl; // روابط الصور الإضافية
  
  // معلومات التمرين الأصلي
  final String originalTitle; // عنوان التمرين الأصلي
  final String originalDescription; // وصف التمرين الأصلي
  final String originalImageUrl; // رابط الصورة الأصلية
  final List<String> originalGalleryImages; // روابط الصور الإضافية الأصلية
  final int level; // مستوى التمرين
  final bool isFavorite; // هل التمرين مفضل
  final DateTime createdAt; // تاريخ الإنشاء
  final DateTime updatedAt; // تاريخ التحديث
  
  // خصائص إضافية للتمارين المخصصة
  final double lastWeight; // الوزن الأخير المستخدم
  final int lastReps; // عدد التكرارات الأخيرة
  final int lastSets; // عدد المجموعات الأخيرة
  final String notes; // ملاحظات شخصية
  final bool isCustom; // هل هذا تمرين مخصص
  final String localImagePath; // مسار الصورة المحلية إذا تم تغييرها
  final bool isCompleted; // هل تم إكمال التمرين

  CustomExercise({
    required this.id,
    required this.originalExerciseId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.mainImageUrl,
    required this.imageUrl,
    required this.level,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.originalTitle,
    required this.originalDescription,
    required this.originalImageUrl,
    required this.originalGalleryImages,
    this.lastWeight = 0,
    this.lastReps = 0,
    this.lastSets = 0,
    this.notes = '',
    this.isCustom = true,
    this.localImagePath = '',
    this.isCompleted = false,
  });

  /// إنشاء تمرين مخصص من تمرين أساسي
  factory CustomExercise.fromExercise(Exercise exercise, {
    String? id,
    double lastWeight = 0,
    int lastReps = 0,
    int lastSets = 0,
    String notes = '',
    String localImagePath = '',
    bool isCompleted = false,
  }) {
    return CustomExercise(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      originalExerciseId: exercise.id,
      categoryId: exercise.categoryId,
      title: exercise.title,
      description: exercise.description,
      mainImageUrl: exercise.mainImageUrl,
      imageUrl: exercise.imageUrl,
      level: exercise.level,
      isFavorite: exercise.isFavorite,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      originalTitle: exercise.title,
      originalDescription: exercise.description,
      originalImageUrl: exercise.mainImageUrl,
      originalGalleryImages: exercise.imageUrl,
      lastWeight: lastWeight,
      lastReps: lastReps,
      lastSets: lastSets,
      notes: notes,
      localImagePath: localImagePath,
      isCompleted: isCompleted,
    );
  }

  /// إنشاء تمرين مخصص جديد تماماً
  factory CustomExercise.create({
    required int categoryId,
    required String title,
    required String description,
    required String mainImageUrl,
    required List<String> imageUrl,
    required int level,
    double lastWeight = 0,
    int lastReps = 0,
    int lastSets = 0,
    String notes = '',
    String localImagePath = '',
    bool isCompleted = false,
  }) {
    final now = DateTime.now();
    return CustomExercise(
      id: now.millisecondsSinceEpoch.toString(),
      originalExerciseId: 0, // تمرين جديد ليس له أصل
      categoryId: categoryId,
      title: title,
      description: description,
      mainImageUrl: mainImageUrl,
      imageUrl: imageUrl,
      level: level,
      isFavorite: false,
      createdAt: now,
      updatedAt: now,
      originalTitle: title,
      originalDescription: description,
      originalImageUrl: mainImageUrl,
      originalGalleryImages: imageUrl,
      lastWeight: lastWeight,
      lastReps: lastReps,
      lastSets: lastSets,
      notes: notes,
      localImagePath: localImagePath,
      isCompleted: isCompleted,
    );
  }

  /// تحويل التمرين المخصص إلى JSON للتخزين
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalExerciseId': originalExerciseId,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'mainImageUrl': mainImageUrl,
      'imageUrl': imageUrl,
      'level': level,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'originalTitle': originalTitle,
      'originalDescription': originalDescription,
      'originalImageUrl': originalImageUrl,
      'originalGalleryImages': originalGalleryImages,
      'lastWeight': lastWeight,
      'lastReps': lastReps,
      'lastSets': lastSets,
      'notes': notes,
      'isCustom': isCustom,
      'localImagePath': localImagePath,
      'isCompleted': isCompleted,
    };
  }

  /// إنشاء تمرين مخصص من JSON
  factory CustomExercise.fromJson(Map<String, dynamic> json) {
    return CustomExercise(
      id: json['id'],
      originalExerciseId: json['originalExerciseId'],
      categoryId: json['categoryId'],
      title: json['title'],
      description: json['description'],
      mainImageUrl: json['mainImageUrl'],
      imageUrl: List<String>.from(json['imageUrl']),
      level: json['level'],
      isFavorite: json['isFavorite'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      originalTitle: json['originalTitle'],
      originalDescription: json['originalDescription'],
      originalImageUrl: json['originalImageUrl'],
      originalGalleryImages: List<String>.from(json['originalGalleryImages']),
      lastWeight: json['lastWeight'],
      lastReps: json['lastReps'],
      lastSets: json['lastSets'],
      notes: json['notes'],
      isCustom: json['isCustom'],
      localImagePath: json['localImagePath'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  /// نسخة معدلة من التمرين المخصص
  CustomExercise copyWith({
    String? id,
    int? originalExerciseId,
    int? categoryId,
    String? title,
    String? description,
    String? mainImageUrl,
    List<String>? imageUrl,
    int? level,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? originalTitle,
    String? originalDescription,
    String? originalImageUrl,
    List<String>? originalGalleryImages,
    double? lastWeight,
    int? lastReps,
    int? lastSets,
    String? notes,
    bool? isCustom,
    String? localImagePath,
    bool? isCompleted,
  }) {
    return CustomExercise(
      id: id ?? this.id,
      originalExerciseId: originalExerciseId ?? this.originalExerciseId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      level: level ?? this.level,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      originalTitle: originalTitle ?? this.originalTitle,
      originalDescription: originalDescription ?? this.originalDescription,
      originalImageUrl: originalImageUrl ?? this.originalImageUrl,
      originalGalleryImages: originalGalleryImages ?? this.originalGalleryImages,
      lastWeight: lastWeight ?? this.lastWeight,
      lastReps: lastReps ?? this.lastReps,
      lastSets: lastSets ?? this.lastSets,
      notes: notes ?? this.notes,
      isCustom: isCustom ?? this.isCustom,
      localImagePath: localImagePath ?? this.localImagePath,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// تحويل التمرين المخصص إلى تمرين عادي
  Exercise toExercise() {
    return Exercise(
      id: originalExerciseId,
      categoryId: categoryId,
      title: title,
      description: description,
      mainImageUrl: localImagePath.isNotEmpty ? localImagePath : mainImageUrl,
      imageUrl: imageUrl,
      level: level,
      isFavorite: isFavorite,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    originalExerciseId,
    categoryId,
    title,
    description,
    mainImageUrl,
    imageUrl,
    level,
    isFavorite,
    createdAt,
    updatedAt,
    originalTitle,
    originalDescription,
    originalImageUrl,
    originalGalleryImages,
    lastWeight,
    lastReps,
    lastSets,
    notes,
    isCustom,
    localImagePath,
  ];
}
