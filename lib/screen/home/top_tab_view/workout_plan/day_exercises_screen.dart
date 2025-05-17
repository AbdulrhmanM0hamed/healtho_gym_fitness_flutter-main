import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/day_exercises_row.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/workout_exercises_screen.dart';

class DayExercisesScreen extends StatefulWidget {
  const DayExercisesScreen({super.key});

  @override
  State<DayExercisesScreen> createState() => _DayExercisesScreenState();
}

class _DayExercisesScreenState extends State<DayExercisesScreen> {
  List listArr = [
    {
      "name": "Bench Press",
      "sets": "3",
      "reps": "12 - 10 - 0",
      "rest": "30 Sec",
      "image": "assets/img/d1.png",
      "is_complete": false,
    },
    {
      "name": "Bench Press",
      "sets": "3",
      "reps": "12 - 10 - 0",
      "rest": "30 Sec",
      "image": "assets/img/d2.png",
      "is_complete": true,
    },
    {
      "name": "Bench Press",
      "sets": "3",
      "reps": "12 - 10 - 0",
      "rest": "30 Sec",
      "image": "assets/img/d3.png",
      "is_complete": false,
    },
    {
      "name": "Bench Press",
      "sets": "3",
      "reps": "12 - 10 - 0",
      "rest": "30 Sec",
      "image": "assets/img/d4.png",
      "is_complete": false,
    },
    {
      "name": "Bench Press",
      "sets": "3",
      "reps": "12 - 10 - 0",
      "rest": "30 Sec",
      "image": "assets/img/d5.png",
      "is_complete": false,
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
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Reset",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        itemBuilder: (context, index) {
          var obj = listArr[index] as Map? ?? {};

          return DayExerciseRow(
              obj: obj,
              onPressed: () {
                context.push(const WorkoutExercisesDetailScreen());
              });
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 20,
        ),
        itemCount: listArr.length,
      ),
    );
  }
}
