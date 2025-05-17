import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/top_tab_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/challenges/challenges_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/dietician/dietician_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/health_tip/health_tip_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/profile/profile_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/trainer/trainer_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/workout_plan_screen.dart';

class TopTabViewScreen extends StatefulWidget {
  const TopTabViewScreen({super.key});

  @override
  State<TopTabViewScreen> createState() => _TopTabViewScreenState();
}

class _TopTabViewScreenState extends State<TopTabViewScreen>
    with SingleTickerProviderStateMixin {
  var tapArr = [
    "Health Tips",
    "Exercises",
    "Workout Plan",
    "Challenges",
    "Trainers",
    "Dietician",
    "Profile"
  ];

  int selectTab = 0;
  TabController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 7, vsync: this);
    controller?.addListener(() {
      setState(() {
        selectTab = controller?.index.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        centerTitle: false,
        leading: Container(),
        leadingWidth: 20,
        title: const Text(
          "Healtho",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          //TODO: Top Tab Bar
          Container(
            margin: const EdgeInsets.only(top: 0.5),
            color: TColor.secondary,
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: tapArr.map((name) {
                    var index = tapArr.indexOf(name);

                    return TopTabButton(
                        title: name,
                        isSelect: selectTab == index,
                        onPressed: () {
                          setState(() {
                            selectTab = index;
                            controller?.animateTo(index);
                          });
                        });
                  }).toList(),
                ),
              ),
            ),
          ),

          //TODO: Tab View

          Expanded(
            child: TabBarView(
              controller: controller,
              children: const [
                HealthTipScreen(),
                ExercisesScreen(),
                WorkoutPlanScreen(),
                ChallengesScreen(),
                TrainerTabScreen(),
                DieticianTabScreen(),
                ProfileTabScreen(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
