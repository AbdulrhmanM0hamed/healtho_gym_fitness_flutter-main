import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ExerciseDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ExerciseDetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: TColor.placeholder,
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }
} 