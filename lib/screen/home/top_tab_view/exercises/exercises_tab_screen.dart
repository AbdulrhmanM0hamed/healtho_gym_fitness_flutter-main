import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_cell.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_name_screen.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List listArr = [
    {
      "title": "Chest",
      "subtitle": "16 Exercises",
      "image": "assets/img/ex_1.png"
    },
    {
      "title": "Back",
      "subtitle": "16 Exercises",
      "image": "assets/img/ex_2.png"
    },
    {
      "title": "Biceps",
      "subtitle": "16 Exercises",
      "image": "assets/img/ex_3.png"
    },
    {
      "title": "Triceps",
      "subtitle": "16 Exercises",
      "image": "assets/img/ex_4.png"
    },
    {
      "title": "Shoulders",
      "subtitle": "16 Exercises",
      "image": "assets/img/ex_5.png"
    },
    {
      "title": "Abs",
      "subtitle": "16 Exercises",
      "image": "assets/img/ex_6.png"
    },
    {
      "title": "Legs",
      "subtitle": "16 Exercises",
      "image": "assets/img/ex_7.png"
    },
    {
      "title": "Chest",
      "subtitle": "16 Exercises",
      "image": "assets/img/ex_8.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15),
      itemBuilder: (context, index) {
        var obj = listArr[index] as Map? ?? {};

        return ExercisesCell(obj: obj, onPressed: (){
            context.push(const ExercisesNameScreen());
        },);
      },
      itemCount: listArr.length,
    ));
  }
}
