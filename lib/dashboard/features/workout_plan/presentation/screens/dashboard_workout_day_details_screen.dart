import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_day_exercise_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_cubit.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_state.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/widgets/dashboard_day_exercise_form.dart';
import 'package:healtho_gym/core/widgets/loading_indicator.dart';
import 'package:healtho_gym/core/widgets/error_view.dart';

/// شاشة تفاصيل يوم التمرين في لوحة التحكم
class DashboardWorkoutDayDetailsScreen extends StatefulWidget {
  final int dayId;
  final int dayNumber;
  final int weekId;

  const DashboardWorkoutDayDetailsScreen({
    Key? key,
    required this.dayId,
    required this.dayNumber,
    required this.weekId,
  }) : super(key: key);

  @override
  State<DashboardWorkoutDayDetailsScreen> createState() => _DashboardWorkoutDayDetailsScreenState();
}

class _DashboardWorkoutDayDetailsScreenState extends State<DashboardWorkoutDayDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    context.read<DashboardWorkoutPlanCubit>().getExercisesForDay(widget.dayId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getDayName(widget.dayNumber)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadExercises();
        },
        child: BlocConsumer<DashboardWorkoutPlanCubit, DashboardWorkoutPlanState>(
          listener: (context, state) {
            if (state is DashboardWorkoutPlanActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              
              // Reload data after successful action
              if (state.entityType == 'exercise') {
                _loadExercises();
              }
            }
          },
          builder: (context, state) {
            // First check if we have exercises data to display
            if (state is DashboardDayExercisesLoaded && state.dayId == widget.dayId) {
              return _buildExercisesList(context, state.exercises);
            }
            
            // Check for loading state
            if (state is DashboardWorkoutPlanLoading) {
              return const Center(child: LoadingIndicator());
            } 
            
            // Check for error state
            else if (state is DashboardWorkoutPlanError) {
              return ErrorView(
                message: state.message,
                onRetry: _loadExercises,
              );
            } 
            
            // Check for success action state
            else if (state is DashboardWorkoutPlanActionSuccess) {
              // Automatically reload data after a short delay
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  _loadExercises();
                }
              });
              
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadExercises,
                      child: const Text('تحديث البيانات'),
                    ),
                  ],
                ),
              );
            } 
            
            // Fallback - show loading instead of "choose a day"
            else {
              // Try to load exercises again
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  _loadExercises();
                }
              });
              
              return const Center(child: LoadingIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getDayName(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return 'اليوم الأول';
      case 2:
        return 'اليوم الثاني';
      case 3:
        return 'اليوم الثالث';
      case 4:
        return 'اليوم الرابع';
      case 5:
        return 'اليوم الخامس';
      case 6:
        return 'اليوم السادس';
      case 7:
        return 'اليوم السابع';
      default:
        return 'اليوم $dayNumber';
    }
  }

  Widget _buildExercisesList(BuildContext context, List<DashboardDayExerciseModel> exercises) {
    if (exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'لا توجد تمارين في هذا اليوم',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'اضغط على زر الإضافة لإضافة تمرين جديد',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _showAddExerciseDialog(context),
              child: const Text('إضافة تمرين'),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      onReorder: (oldIndex, newIndex) {
        // تنفيذ إعادة ترتيب التمارين
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        
        setState(() {
          final item = exercises.removeAt(oldIndex);
          exercises.insert(newIndex, item);
          
          // تحديث ترتيب التمارين
          for (int i = 0; i < exercises.length; i++) {
            final exercise = exercises[i];
            if (exercise.sortOrder != i + 1) {
              final updatedExercise = exercise.copyWith(sortOrder: i + 1);
              context.read<DashboardWorkoutPlanCubit>().updateExercise(updatedExercise);
            }
          }
        });
      },
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          key: Key('exercise_${exercise.id}'),
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: exercise.exerciseDetails?.mainImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      exercise.exerciseDetails!.mainImageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fitness_center),
                        );
                      },
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fitness_center),
                  ),
            title: Text(
              exercise.exerciseName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'المجموعات: ${exercise.sets} × التكرارات: ${exercise.reps}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                  const SizedBox(height: 4),
                  Text('وقت الراحة: ${exercise.restTime} ثانية'),
                if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('ملاحظات: ${exercise.notes}'),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditExerciseDialog(context, exercise),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteExercise(context, exercise),
                ),
                const Icon(Icons.drag_handle),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();
    
    final newExercise = DashboardDayExerciseModel(
      dayId: widget.dayId,
      exerciseId: 1, // Default exercise ID
      sets: 3,
      reps: 12,
      restTime: 60,
      weight: 0,
      notes: '',
      sortOrder: 1,
      exerciseName: 'تمرين جديد', // Default exercise name
      exerciseImage: '', // Default empty image URL
    );

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: DashboardDayExerciseForm(
          exercise: newExercise,
          onSubmit: (exercise) {
            // استخدم مرجع الـ cubit المحفوظ بدلاً من محاولة قراءته من سياق الحوار
            cubit.addExerciseToDay(exercise);
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _showEditExerciseDialog(BuildContext context, DashboardDayExerciseModel exercise) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: DashboardDayExerciseForm(
          exercise: exercise,
          onSubmit: (updatedExercise) {
            // استخدم مرجع الـ cubit المحفوظ بدلاً من محاولة قراءته من سياق الحوار
            cubit.updateExercise(updatedExercise);
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _confirmDeleteExercise(BuildContext context, DashboardDayExerciseModel exercise) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف تمرين "${exercise.exerciseName}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // استخدم مرجع الـ cubit المحفوظ بدلاً من محاولة قراءته من سياق الحوار
              cubit.deleteExercise(exercise.id!, widget.dayId);
              Navigator.pop(dialogContext);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
