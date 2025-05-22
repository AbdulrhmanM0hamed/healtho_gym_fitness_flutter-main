import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ExerciseCompletionButton extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onToggle;

  const ExerciseCompletionButton({
    Key? key,
    required this.isCompleted,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isCompleted
                  ? "assets/img/check_tick.png"
                  : "assets/img/uncheck.png",
              width: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "Mark as completed",
              style: TextStyle(
                color: isCompleted
                    ? const Color(0xff27AE60)
                    : TColor.placeholder,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
} 