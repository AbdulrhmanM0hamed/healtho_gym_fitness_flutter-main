import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ExerciseCountItem extends StatelessWidget {
  final String label;
  final String count;

  const ExerciseCountItem({
    Key? key,
    required this.label,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 12,
          ),
        ),
        Text(
          count,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 