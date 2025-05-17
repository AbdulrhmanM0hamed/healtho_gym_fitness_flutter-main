import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/round_dropdown.dart';
import 'package:healtho_gym/common_widget/round_text_field.dart';

class CreateNewPlanScreen extends StatefulWidget {
  const CreateNewPlanScreen({super.key});

  @override
  State<CreateNewPlanScreen> createState() => _CreateNewPlanScreenState();
}

class _CreateNewPlanScreenState extends State<CreateNewPlanScreen> {
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
          "Add Plan",
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
              child: RoundTextField(
                hintText: "Plan Name",
                radius: 10,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(hintText: "Goal", list: [
                {"name": "Goal"},
                {"name": "Goal"},
              ]),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(hintText: "Duration", list: [
                {"name": "10 min"},
                {"name": "20 min"},
              ]),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(hintText: "Choose Level", list: [
                {"name": "1"},
                {"name": "2"},
              ]),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RoundButton(title: "Add Plan", onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }
}
