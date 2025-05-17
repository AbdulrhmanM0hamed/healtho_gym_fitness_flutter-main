import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/title_value_row.dart';

class WorkoutIntroductionScreen extends StatelessWidget {
  const WorkoutIntroductionScreen({super.key});

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
          "Introduction",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Complete the Beginner Program",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Description",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "This is a beginner quick start guide that will move you from day 1 to day 60, providing you with starting training and instructions...",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const TitleValueRow(title: "Duration", value: "5 Weeks"),
              const TitleValueRow(title: "Goal", value: "Muscle Building"),
              const TitleValueRow(title: "Training Level", value: "Beginner"),
              const TitleValueRow(title: "Days per Week", value: "4 days"),
              const TitleValueRow(title: "Target Gender", value: "Male and Female")
            ],
          ),
        ),
      ),
    );
  }
}
