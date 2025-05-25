import 'package:flutter/material.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_day_exercise_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/theme/workout_plan_theme.dart';

/// بطاقة عرض تمرين
class ExerciseCard extends StatelessWidget {
  final DashboardDayExerciseModel exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isReorderable;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onEdit,
    required this.onDelete,
    this.isReorderable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: WorkoutPlanTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildExerciseImage(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.exerciseName,
                            style: WorkoutPlanTheme.titleStyle,
                          ),
                          const SizedBox(height: 4),
                          _buildExerciseStats(),
                        ],
                      ),
                    ),
                    _buildActions(),
                  ],
                ),
                if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'ملاحظات:',
                    style: WorkoutPlanTheme.captionStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.notes!,
                    style: WorkoutPlanTheme.bodyStyle,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: exercise.exerciseImage != null && exercise.exerciseImage.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                exercise.exerciseImage!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.fitness_center, size: 32, color: Colors.grey),
                  );
                },
              ),
            )
          : const Center(
              child: Icon(Icons.fitness_center, size: 32, color: Colors.grey),
            ),
    );
  }

  Widget _buildExerciseStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.repeat, size: 16, color: WorkoutPlanTheme.primaryColor),
            const SizedBox(width: 4),
            Text(
              '${exercise.sets} مجموعات × ${exercise.reps} تكرار',
              style: WorkoutPlanTheme.bodyStyle,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.timer, size: 16, color: WorkoutPlanTheme.secondaryColor),
            const SizedBox(width: 4),
            Text(
              'راحة: ${exercise.restTime} ثانية',
              style: WorkoutPlanTheme.bodyStyle,
            ),
          ],
        ),
        if (exercise.weight != null && exercise.weight! > 0) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.fitness_center, size: 16, color: WorkoutPlanTheme.accentColor),
              const SizedBox(width: 4),
              Text(
                'وزن: ${exercise.weight} كجم',
                style: WorkoutPlanTheme.bodyStyle,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: WorkoutPlanTheme.secondaryColor),
          tooltip: 'تعديل',
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: WorkoutPlanTheme.errorColor),
          tooltip: 'حذف',
          onPressed: onDelete,
        ),
        if (isReorderable)
          const Icon(Icons.drag_handle, color: WorkoutPlanTheme.textSecondaryColor),
      ],
    );
  }
}
