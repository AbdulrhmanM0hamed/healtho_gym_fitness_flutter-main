import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/toast_helper.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/models/exercise_category_model.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/screens/add_edit_category_screen.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_state.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/screens/exercises_screen.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/widgets/category_card.dart';

class ExerciseCategoriesScreen extends StatefulWidget {
  const ExerciseCategoriesScreen({super.key});

  @override
  State<ExerciseCategoriesScreen> createState() => _ExerciseCategoriesScreenState();
}

class _ExerciseCategoriesScreenState extends State<ExerciseCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: TColor.secondary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'فئات التمارين',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'إدارة وتنظيم فئات التمارين',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.read<ExerciseCategoryCubit>().loadCategories(),
                        icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                        tooltip: 'تحديث القائمة',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<ExerciseCategoryCubit, ExerciseCategoryState>(
        listener: (context, state) {
          if (state is ExerciseCategoryDeleted) {
            ToastHelper.showFlushbar(
              context: context,
              title: 'تم الحذف بنجاح',
              message: 'تم حذف الفئة وجميع التمارين المرتبطة بها',
              type: ToastType.success,
            );
          } else if (state is ExerciseCategoryError) {
            ToastHelper.showFlushbar(
              context: context,
              title: 'خطأ',
              message: state.message,
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is ExerciseCategoryLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: TColor.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'جاري تحميل الفئات...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ExerciseCategoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'عذراً، حدث خطأ',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<ExerciseCategoryCubit>().loadCategories(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    label: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ExerciseCategoryLoaded) {
            if (state.categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'لا توجد فئات حالياً',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'قم بإضافة فئة جديدة لبدء تنظيم التمارين',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToAddCategory(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                      label: const Text(
                        'إضافة فئة جديدة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExerciseCategoryCubit>().loadCategories();
              },
              color: TColor.primary,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return _buildCategoryCard(context, category);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddCategory(context),
        backgroundColor: TColor.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'إضافة فئة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, ExerciseCategory category) {
    return CategoryCard(
      category: category,
      onView: () => _navigateToExercises(context, category),
      onEdit: () => _navigateToEditCategory(context, category),
      onDelete: () => _showDeleteConfirmationDialog(context, category),
    );
  }

  void _navigateToAddCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditCategoryScreen(),
      ),
    ).then((value) {
      if (value == true) {
        context.read<ExerciseCategoryCubit>().loadCategories();
        ToastHelper.showFlushbar(
          context: context,
          title: 'تمت الإضافة بنجاح',
          message: 'تم إضافة الفئة الجديدة بنجاح',
          type: ToastType.success,
        );
      }
    });
  }

  void _navigateToEditCategory(BuildContext context, ExerciseCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCategoryScreen(category: category),
      ),
    ).then((value) {
      if (value == true) {
        context.read<ExerciseCategoryCubit>().loadCategories();
        ToastHelper.showFlushbar(
          context: context,
          title: 'تم التعديل بنجاح',
          message: 'تم تعديل الفئة بنجاح',
          type: ToastType.success,
        );
      }
    });
  }

  void _navigateToExercises(BuildContext context, ExerciseCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisesScreen(
          categoryId: category.id,
          categoryTitle: category.titleAr,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ExerciseCategory category) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل أنت متأكد من حذف فئة "${category.titleAr}"؟',
              style: const TextStyle(fontSize: 16),
            ),
            if (category.exercisesCount > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تحتوي هذه الفئة على ${category.exercisesCount} تمرين. سيتم حذف جميع التمارين المرتبطة بها.',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.read<ExerciseCategoryCubit>().deleteCategory(category.id);
              Navigator.pop(dialogContext);
            },
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            label: const Text(
              'حذف',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 