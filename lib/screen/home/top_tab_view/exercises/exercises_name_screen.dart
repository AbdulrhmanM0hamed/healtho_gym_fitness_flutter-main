import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_row.dart';
import 'package:healtho_gym/screen/home/top_tab_view/health_tip/health_tip_row.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/workout_exercises_screen.dart';

class ExercisesNameScreen extends StatefulWidget {
  const ExercisesNameScreen({super.key});

  @override
  State<ExercisesNameScreen> createState() => _ExercisesNameScreenState();
}

class _ExercisesNameScreenState extends State<ExercisesNameScreen> {
  List listArr = [
    {
      "title": "Bench press",
      "image": "assets/img/l_1.png",
    },
    {
      "title": "Incline press",
      "image": "assets/img/l_2.png",
    },
    {
      "title": "Decline Press",
      "image": "assets/img/l_3.png",
    },
    {
      "title": "Dumbbell Flys",
      "image": "assets/img/l_4.png",
    },
    {
      "title": "Dumbbell Flys",
      "image": "assets/img/l_5.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        centerTitle: false,
        title: const Text(
          "Chest",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 0.5),
            width: double.maxFinite,
            color: TColor.secondary,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      icon: Container(
                        width: 50,
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/img/down_white.png",
                          width: 15,
                        ),
                      ),
                      hint: const Text(
                        "Select Level",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      items: ["Level 1", "Level 2"]
                          .map((obj) => DropdownMenuItem(
                              value: obj,
                              child: Text(
                                obj,
                                style: TextStyle(
                                  color: TColor.btnPrimaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              )))
                          .toList(),
                      onChanged: (value) {},
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemBuilder: (context, index) {
                  var obj = listArr[index] as Map? ?? {};
                  return ExercisesRow(
                    obj: obj,
                    onPressed: () {
                      context.push(const WorkoutExercisesDetailScreen());
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                itemCount: listArr.length),
          ),
        ],
      ),
    );
  }
}
