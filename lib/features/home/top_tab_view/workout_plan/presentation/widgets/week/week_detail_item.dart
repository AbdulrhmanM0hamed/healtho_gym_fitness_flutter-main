import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/number_title_subtitle_button.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/workout_week_model.dart';

class WeekDetailItem extends StatelessWidget {
  final WorkoutWeekModel week;
  final VoidCallback onPressed;

  const WeekDetailItem({
    Key? key,
    required this.week,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberTitleSubtitleButton(
      title: "الأسبوع ${week.weekNumber}",
      subtitle: week.description,
      number: week.weekNumber.toString().padLeft(2, '0'),
      onPressed: onPressed,
    );
  }
} 