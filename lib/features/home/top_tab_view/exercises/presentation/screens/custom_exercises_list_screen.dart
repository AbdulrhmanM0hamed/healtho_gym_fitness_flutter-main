import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/theme/app_colors.dart';
import 'package:healtho_gym/common/custom_app_bar.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/custom_exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/custom_exercises_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/custom_exercises_state.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/screens/custom_exercise_screen.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// شاشة قائمة التمارين المخصصة
class CustomExercisesListScreen extends StatefulWidget {
  final ExerciseCategory category;
  final int level;

  const CustomExercisesListScreen({
    Key? key,
    required this.category,
    required this.level,
  }) : super(key: key);

  @override
  State<CustomExercisesListScreen> createState() =>
      _CustomExercisesListScreenState();
}

class _CustomExercisesListScreenState extends State<CustomExercisesListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    context
        .read<CustomExercisesCubit>()
        .loadExercises(widget.category, widget.level);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: '${widget.category.title} - المستوى ${widget.level}',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.secondary,
        titleColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _loadExercises,
          ),
        ],
      ),
      body: BlocBuilder<CustomExercisesCubit, CustomExercisesState>(
        builder: (context, state) {
          if (state is CustomExercisesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomExercisesLoaded) {
            return _buildExercisesList(state);
          } else if (state is CustomExercisesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'حدث خطأ: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadExercises,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('لا توجد تمارين متاحة'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewExercise,
        backgroundColor: TColor.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildExercisesList(CustomExercisesLoaded state) {
    final customExercises = state.customExercises;

    // إذا لم تكن هناك تمارين مخصصة
    if (customExercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.fitness_center, size: 80, color: TColor.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد تمارين مخصصة',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TColor.secondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'قم بإنشاء تمارينك الخاصة لتتبع تقدمك وتخصيص خطة تمارينك',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _createNewExercise,
              icon: const Icon(Icons.add),
              label: const Text('إنشاء تمرين جديد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      );
    }

    // إنشاء قائمة من التمارين المخصصة فقط
    final List<Widget> exerciseWidgets = [];

    // إضافة عنوان للتمارين المخصصة
    exerciseWidgets.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التمارين المخصصة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.secondary,
              ),
            ),
            Text(
              '${customExercises.length} تمرين',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );

    // إضافة التمارين المخصصة
    for (final exercise in customExercises) {
      exerciseWidgets.add(_buildCustomExerciseCard(exercise));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: exerciseWidgets,
    );
  }

  Widget _buildCustomExerciseCard(CustomExercise exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToCustomExerciseDetails(exercise),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة التمرين
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: exercise.localImagePath.isNotEmpty
                    ? Image.file(
                        File(exercise.localImagePath),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: exercise.mainImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            // معلومات التمرين
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          exercise.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          // زر حذف التمرين
                          InkWell(
                            onTap: () => _showDeleteConfirmation(exercise),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // علامة تمرين مخصص
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.edit,
                                    size: 16, color: TColor.primary),
                                const SizedBox(width: 4),
                                Text(
                                  'مخصص',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: TColor.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // معلومات الوزن والتكرارات
                  if (exercise.lastWeight > 0 ||
                      exercise.lastReps > 0 ||
                      exercise.lastSets > 0)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            Icons.fitness_center,
                            '${exercise.lastWeight} كجم',
                            'الوزن',
                          ),
                          _buildStatItem(
                            Icons.repeat,
                            '${exercise.lastReps}',
                            'تكرار',
                          ),
                          _buildStatItem(
                            Icons.format_list_numbered,
                            '${exercise.lastSets}',
                            'مجموعة',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تم إزالة دالة _buildOriginalExerciseCard لأنها لم تعد مستخدمة

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: TColor.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _navigateToCustomExerciseDetails(CustomExercise exercise) async {
    // الحصول على التمرين الأصلي
    final originalExercise = Exercise(
      isFavorite: exercise.isFavorite,
      createdAt: exercise.createdAt,
      updatedAt: exercise.updatedAt,
      id: exercise.originalExerciseId,
      categoryId: exercise.categoryId,
      title: exercise.originalTitle,
      description: exercise.originalDescription,
      mainImageUrl: exercise.originalImageUrl,
      imageUrl: exercise.originalGalleryImages,
      level: exercise.level,
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<CustomExercisesCubit>(),
          child: CustomExerciseScreen(
            originalExercise: originalExercise,
            customExercise: exercise,
          ),
        ),
      ),
    );

    if (result == true) {
      _loadExercises();
    }
  }

  // تم إزالة دالة _navigateToCustomizeExercise لأنها لم تعد مستخدمة

  // عرض مربع حوار تأكيد الحذف
  void _showDeleteConfirmation(CustomExercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            const Text('حذف التمرين'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هل أنت متأكد من حذف التمرين "${exercise.title}"?'),
            const SizedBox(height: 8),
            Text(
              'سيتم حذف جميع البيانات المتعلقة بهذا التمرين بما في ذلك الصور والملاحظات.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCustomExercise(exercise);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  // حذف التمرين المخصص
  void _deleteCustomExercise(CustomExercise exercise) async {
    try {
      // عرض مؤشر التحميل
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جاري حذف التمرين...')),
      );

      // حذف التمرين باستخدام Cubit
      await context.read<CustomExercisesCubit>().deleteCustomExercise(
            exercise.id,
            exercise.localImagePath,
          );

      // عرض رسالة نجاح
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف التمرين بنجاح')),
        );
      }

      // إعادة تحميل التمارين
      _loadExercises();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء حذف التمرين: $e')),
        );
      }
    }
  }

  // إنشاء تمرين جديد من الصفر
  void _createNewExercise() async {
    // إنشاء تمرين فارغ كقالب
    final emptyExercise = Exercise(
      id: -1, // معرف سالب يشير إلى أنه تمرين جديد
      categoryId: widget.category.id,
      title: '',
      description: '',
      mainImageUrl: '',
      imageUrl: const [],
      level: widget.level,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<CustomExercisesCubit>(),
          child: CustomExerciseScreen(
            originalExercise: emptyExercise,
            isNewExercise: true, // تعيين علامة أنه تمرين جديد
          ),
        ),
      ),
    );

    if (result == true) {
      _loadExercises();
    }
  }
}
