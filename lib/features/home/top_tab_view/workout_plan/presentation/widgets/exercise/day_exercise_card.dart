import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/common/exercise_image.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/exercise/exercise_completion_button.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/exercise/exercise_detail_row.dart';

class DayExerciseCard extends StatelessWidget {
  final String name;
  final String sets;
  final String reps;
  final String restTime;
  final String imageUrl;
  final bool isCompleted;
  final VoidCallback onPressed;
  final VoidCallback? onToggleComplete;

  const DayExerciseCard({
    Key? key,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restTime,
    required this.imageUrl,
    required this.isCompleted,
    required this.onPressed,
    this.onToggleComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: TColor.txtBG,
          border: Border.all(color: TColor.board, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExerciseImage(imageUrl: imageUrl),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ExerciseDetailRow(label: "Sets", value: sets),
                        ExerciseDetailRow(label: "Reps", value: reps),
                        ExerciseDetailRow(label: "Rest", value: restTime),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Image.asset(
                    "assets/img/next.png",
                    width: 12,
                    color: TColor.placeholder,
                  )
                ],
              ),
            ),
            Container(
              color: TColor.board,
              height: 2,
            ),
            if (onToggleComplete != null)
              ExerciseCompletionButton(
                isCompleted: isCompleted,
                onToggle: onToggleComplete!,
              ),
          ],
        ),
      ),
    );
  }
} 