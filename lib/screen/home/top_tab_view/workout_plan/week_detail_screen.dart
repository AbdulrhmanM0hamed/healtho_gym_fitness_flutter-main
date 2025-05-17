import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/day_exercises_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/week_day_exercise_row.dart';

class WeekDetailsScreen extends StatefulWidget {
  const WeekDetailsScreen({super.key});

  @override
  State<WeekDetailsScreen> createState() => _WeekDetailsScreenState();
}

class _WeekDetailsScreenState extends State<WeekDetailsScreen> {
  List daysArr = [
    {
      "name": "Mon",
      "total": "10",
      "major": "7",
      "minor": "3",
      "is_rest": false
    },
    {
      "name": "Tue",
      "total": "10",
      "major": "7",
      "minor": "3",
      "is_rest": false
    },
    {"name": "Wed", "total": "0", "major": "0", "minor": "0", "is_rest": true},
    {
      "name": "Thu",
      "total": "10",
      "major": "7",
      "minor": "3",
      "is_rest": false
    },
    {
      "name": "Fri",
      "total": "10",
      "major": "7",
      "minor": "3",
      "is_rest": false
    },
    {"name": "Sat", "total": "0", "major": "0", "minor": "0", "is_rest": true},
    {
      "name": "Sat",
      "total": "10",
      "major": "7",
      "minor": "3",
      "is_rest": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: TColor.secondary,
        centerTitle: false,
        title: const Text(
          "Week",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          itemBuilder: (context, index) {
            var obj = daysArr[index] as Map? ?? {};

            return WeekDayExerciseRow(
              obj: obj,
              onPressed: () {
                context.push(const DayExercisesScreen());
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
          itemCount: daysArr.length),
    );
  }
}
