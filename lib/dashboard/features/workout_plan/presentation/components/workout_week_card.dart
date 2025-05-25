import 'package:flutter/material.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_week_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/theme/workout_plan_theme.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/utils/workout_plan_utils.dart';

/// بطاقة عرض أسبوع تمرين
class WorkoutWeekCard extends StatelessWidget {
  final DashboardWorkoutWeekModel week;
  final int weekNumber;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WorkoutWeekCard({
    Key? key,
    required this.week,
    required this.weekNumber,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: WorkoutPlanTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildWeekIcon(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            WorkoutPlanUtils.getWeekName(weekNumber),
                            style: WorkoutPlanTheme.titleStyle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الأسبوع رقم: ${week.weekNumber}',
                            style: WorkoutPlanTheme.bodyStyle,
                          ),
                        ],
                      ),
                    ),
                    _buildActions(),
                  ],
                ),
                if (week.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'الوصف:',
                    style: WorkoutPlanTheme.captionStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    week.description,
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

  Widget _buildWeekIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: WorkoutPlanTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          weekNumber.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: WorkoutPlanTheme.secondaryColor,
          ),
        ),
      ),
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
      ],
    );
  }
}
