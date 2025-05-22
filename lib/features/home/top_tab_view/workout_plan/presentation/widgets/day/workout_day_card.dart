import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/common/exercise_count_item.dart';

class WorkoutDayCard extends StatelessWidget {
  final String dayName;
  final int totalExercises;
  final int majorExercises;
  final int minorExercises;
  final bool isRestDay;
  final VoidCallback onPressed;

  const WorkoutDayCard({
    Key? key,
    required this.dayName,
    required this.totalExercises,
    required this.majorExercises,
    required this.minorExercises,
    required this.isRestDay,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isRestDay ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: TColor.txtBG,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!isRestDay) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  ExerciseCountItem(
                    label: 'Total Exercises',
                    count: totalExercises.toString(),
                  ),
                  const SizedBox(width: 20),
                  ExerciseCountItem(
                    label: 'Major',
                    count: majorExercises.toString(),
                  ),
                  const SizedBox(width: 20),
                  ExerciseCountItem(
                    label: 'Minor',
                    count: minorExercises.toString(),
                  ),
                ],
              ),
            ] else
              const SizedBox(height: 8),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isRestDay ? 'Rest Day' : 'Tap to view exercises',
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
                if (!isRestDay)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: TColor.secondaryText,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 