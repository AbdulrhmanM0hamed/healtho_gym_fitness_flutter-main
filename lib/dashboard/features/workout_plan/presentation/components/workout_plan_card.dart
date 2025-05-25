import 'package:flutter/material.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_plan_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/theme/workout_plan_theme.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/utils/workout_plan_utils.dart';

/// بطاقة عرض خطة تمرين
class WorkoutPlanCard extends StatelessWidget {
  final DashboardWorkoutPlanModel plan;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onToggleFeatured;

  const WorkoutPlanCard({
    Key? key,
    required this.plan,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.onToggleFeatured,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageHeader(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.title,
                            style: WorkoutPlanTheme.titleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (plan.isFeatured)
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildPlanDetails(),
                    const SizedBox(height: 12),
                    _buildPlanTags(),
                    const SizedBox(height: 12),
                    _buildActions(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: plan.mainImageUrl.isNotEmpty
              ? Image.network(
                  plan.mainImageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      ),
                    );
                  },
                )
              : Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.fitness_center, color: Colors.grey, size: 40),
                  ),
                ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: WorkoutPlanTheme.getLevelColor(plan.level),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              WorkoutPlanUtils.getLevelText(plan.level),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: WorkoutPlanTheme.getGenderColor(plan.targetGender),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              WorkoutPlanUtils.getGenderText(plan.targetGender),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: WorkoutPlanTheme.primaryColor),
            const SizedBox(width: 4),
            Text(
              '${plan.durationWeeks} أسبوع',
              style: WorkoutPlanTheme.bodyStyle,
            ),
            const SizedBox(width: 16),
            const Icon(Icons.today, size: 16, color: WorkoutPlanTheme.secondaryColor),
            const SizedBox(width: 4),
            Text(
              '${plan.daysPerWeek} أيام في الأسبوع',
              style: WorkoutPlanTheme.bodyStyle,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.category, size: 16, color: WorkoutPlanTheme.accentColor),
            const SizedBox(width: 4),
            Text(
              _getCategoryName(plan.categoryId),
              style: WorkoutPlanTheme.bodyStyle,
            ),
          ],
        ),
        if (plan.goal.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.flag, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  plan.goal,
                  style: WorkoutPlanTheme.bodyStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPlanTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTag(
          WorkoutPlanUtils.getLevelText(plan.level),
          WorkoutPlanTheme.getLevelColor(plan.level),
        ),
        _buildTag(
          WorkoutPlanUtils.getGenderText(plan.targetGender),
          WorkoutPlanTheme.getGenderColor(plan.targetGender),
        ),
        _buildTag(
          _getCategoryName(plan.categoryId),
          WorkoutPlanTheme.accentColor,
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onToggleFeatured != null)
          IconButton(
            icon: Icon(
              plan.isFeatured ? Icons.star : Icons.star_border,
              color: plan.isFeatured ? Colors.amber : Colors.grey,
            ),
            tooltip: plan.isFeatured ? 'إلغاء التمييز' : 'تمييز',
            onPressed: onToggleFeatured,
          ),
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

  String _getCategoryName(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'بناء العضلات';
      case 2:
        return 'خسارة الوزن';
      case 3:
        return 'اللياقة البدنية';
      default:
        return 'غير محدد';
    }
  }
}
