import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/icon_title_subtitle_button.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/secrtion_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/create_add_plan_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/find_workout_plan_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/workout_detail_screen.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  List muscleArr = [
    {
      "name": "assets/img/wp_1.png",
    },
    {
      "name": "assets/img/wp_2.png",
    },
  ];

  List gainArr = [
    {
      "name": "assets/img/wp_3.png",
    },
    {
      "name": "assets/img/wp_4.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Column(
            children: [
              IconTitleSubtitleButton(
                  title: "Find a Workout Plan",
                  subtitle:
                      "Perfect Workout plan that fulfill your fitness goal",
                  icon: "assets/img/search_circle.png",
                  onPressed: () {

                    context.push(const FindWorkoutPlanScreen());

                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: RoundButton(title: "My Plan", onPressed: () {}),
              ),
              IconTitleSubtitleButton(
                  title: "Create New Plan",
                  subtitle: "Customise workout plans as per your Need",
                  icon: "assets/img/add_big.png",
                  onPressed: () {

                      context.push(const CreateNewPlanScreen());

                  }),
              SectionButton(title: "Muscle Building", onPressed: () {}),
              SizedBox(
                height: (context.width * 0.35) + 16,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemBuilder: (context, index) {
                      var obj = muscleArr[index] as Map? ?? {};

                      return InkWell(
                        onTap: (){
                          context.push(const WorkoutDetailScreen());
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            obj["name"],
                            width: context.width * 0.6,
                            height: context.width * 0.35,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                    itemCount: muscleArr.length),
              ),
              SectionButton(title: "Gain Strength", onPressed: () {}),
              SizedBox(
                height: (context.width * 0.35) + 16,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemBuilder: (context, index) {
                      var obj = gainArr[index] as Map? ?? {};

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          obj["name"],
                          width: context.width * 0.6,
                          height: context.width * 0.35,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                    itemCount: gainArr.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
