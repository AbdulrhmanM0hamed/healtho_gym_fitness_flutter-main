import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/toast_helper.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/models/exercise_model.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/screens/add_edit_exercise_screen.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_state.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/widgets/exercise_card.dart';

class ExercisesScreen extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;

  const ExercisesScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  int _selectedLevel = 1;
  late final ExerciseCubit _exerciseCubit;

  @override
  void initState() {
    super.initState();
    LoggerUtil.info('ExercisesScreen - initState called');
    _exerciseCubit = sl<ExerciseCubit>();
    _loadExercises();
  }

  @override
  void dispose() {
    LoggerUtil.info('ExercisesScreen - dispose called');
    _exerciseCubit.close();
    super.dispose();
  }

  void _loadExercises() {
    _exerciseCubit.loadExercises(widget.categoryId, _selectedLevel);
  }

  @override
  Widget build(BuildContext context) {
    LoggerUtil.info('ExercisesScreen - build called');
    return BlocProvider.value(
      value: _exerciseCubit,
      child: BlocConsumer<ExerciseCubit, ExerciseState>(
        listener: (context, state) {
          if (state is ExerciseDeleted) {
            ToastHelper.showFlushbar(
              context: context,
              title: 'تم الحذف بنجاح',
              message: 'تم حذف التمرين بنجاح',
              type: ToastType.success,
            );
          } else if (state is ExerciseToggledFavorite) {
            ToastHelper.showToast(
              message: state.isFavorite ? 'تمت الإضافة للمفضلة' : 'تمت الإزالة من المفضلة',
              type: state.isFavorite ? ToastType.success : ToastType.info,
            );
          } else if (state is ExerciseError) {
            ToastHelper.showFlushbar(
              context: context,
              title: 'خطأ',
              message: state.message,
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: _buildAppBar(),
            body: _buildBody(state),
            floatingActionButton: _buildFloatingActionButton(),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.secondary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.categoryTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold, // letterSpacing: -0.5,
              letterSpacing: -0.5,
            ),
          ),
       
        ],
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedLevel,
              dropdownColor: TColor.secondary,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: [1, 2, 3].map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.white.withOpacity(0.9),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text('المستوى $level'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLevel = value;
                  });
                  _loadExercises();
                }
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadExercises,
          tooltip: 'تحديث القائمة',
        ),
      ],
    );
  }

  Widget _buildBody(ExerciseState state) {
    if (state is ExerciseLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is ExerciseError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'خطأ: ${state.message}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadExercises,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
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

    if (state is ExerciseLoaded) {
      if (state.exercises.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'لا توجد تمارين في المستوى $_selectedLevel',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'أضف تمرين جديد لبدء القائمة',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _navigateToAddExercise(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'إضافة تمرين جديد',
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

      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: state.exercises.length,
        itemBuilder: (context, index) {
          final exercise = state.exercises[index];
          return ExerciseCard(
            exercise: exercise,
            onEdit: () => _navigateToEditExercise(context, exercise),
            onDelete: () => _showDeleteConfirmationDialog(context, exercise),
            onToggleFavorite: () => _exerciseCubit.toggleFavorite(exercise),
          );
        },
      );
    }

    return const Center(
      child: Text('حدث خطأ غير متوقع'),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      backgroundColor: TColor.primary,
      onPressed: () => _navigateToAddExercise(context),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'إضافة تمرين',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _navigateToAddExercise(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _exerciseCubit,
          child: AddEditExerciseScreen(
            categoryId: widget.categoryId,
            categoryTitle: widget.categoryTitle,
          ),
        ),
      ),
    ).then((value) {
      if (value == true) {
        _loadExercises();
        ToastHelper.showFlushbar(
          context: context,
          title: 'تمت الإضافة بنجاح',
          message: 'تم إضافة التمرين الجديد بنجاح',
          type: ToastType.success,
        );
      }
    });
  }

  void _navigateToEditExercise(BuildContext context, Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _exerciseCubit,
          child: AddEditExerciseScreen(
            categoryId: widget.categoryId,
            categoryTitle: widget.categoryTitle,
            exercise: exercise,
          ),
        ),
      ),
    ).then((value) {
      if (value == true) {
        _loadExercises();
        ToastHelper.showFlushbar(
          context: context,
          title: 'تم التعديل بنجاح',
          message: 'تم تعديل التمرين بنجاح',
          type: ToastType.success,
        );
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              'هل أنت متأكد من حذف تمرين "${exercise.title}"؟',
              style: const TextStyle(fontSize: 16),
            ),
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
                  const Expanded(
                    child: Text(
                      'سيتم حذف جميع الصور المرتبطة بهذا التمرين.',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
              _exerciseCubit.deleteExercise(exercise);
              Navigator.pop(context);
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