import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/round_dropdown.dart';

class FindWorkoutPlanScreen extends StatefulWidget {
  const FindWorkoutPlanScreen({super.key});

  @override
  State<FindWorkoutPlanScreen> createState() => _FindWorkoutPlanScreenState();
}

class _FindWorkoutPlanScreenState extends State<FindWorkoutPlanScreen> {
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
          "Find a Workout Plan",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(hintText: "Choose Goal", list: [
                {"name": "Goal"},
                {"name": "Goal"},
              ]),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(hintText: "Choose Level", list: [
                {"name": "Level"},
                {"name": "Level"},
              ]),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(hintText: "No of weeks", list: [
                {"name": "1"},
                {"name": "2"},
              ]),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(hintText: "Days per week", list: [
                {"name": "1"},
                {"name": "2"},
              ]),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RoundButton(title: "Find Workout Plan", onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }
}
