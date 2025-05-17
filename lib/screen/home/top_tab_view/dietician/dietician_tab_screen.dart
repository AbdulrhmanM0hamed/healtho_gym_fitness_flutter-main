import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/top_tab_view/trainer/trainer_profile_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/trainer/trainer_row.dart';

class DieticianTabScreen extends StatefulWidget {
  const DieticianTabScreen({super.key});

  @override
  State<DieticianTabScreen> createState() => _DieticianTabScreenState();
}

class _DieticianTabScreenState extends State<DieticianTabScreen> {
  List listArr = [
    {
      "name": "Ashish Chutake",
      "detail": "Fitness and Physiotheraphy",
      "image": "assets/img/t1.png",
      "rate": 4.0,
      "location": "Mumbai"
    },
    {
      "name": "Ann Mathewys ",
      "detail": "Weight Loss",
      "image": "assets/img/t2.png",
      "rate": 4.0,
      "location": "Nagpur"
    },
    {
      "name": "Lalit Kalambe",
      "detail": "Fitness and Physiotheraphy",
      "image": "assets/img/t3.png",
      "rate": 4.0,
      "location": "Mumbai"
    },
    {
      "name": "Aditya Khobragade",
      "detail": "power gaining",
      "image": "assets/img/t4.png",
      "rate": 4.0,
      "location": "Bangalore"
    },
    {
      "name": "Ashish Chutake",
      "detail": "Fitness and Physiotheraphy",
      "image": "assets/img/t5.png",
      "rate": 4.0,
      "location": "Chennai"
    },
    {
      "name": "Darshan Barapatre",
      "detail": "Mass gain",
      "image": "assets/img/t6.png",
      "rate": 4.0,
      "location": "Delhi"
    },
    {
      "name": "Saurabh Bhoyar",
      "detail": "Fitness and Physiotheraphy",
      "image": "assets/img/t7.png",
      "rate": 4.0,
      "location": "Mumbai"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        itemBuilder: (context, index) {
          return TrainerRow(
            obj: listArr[index],
            onPressed: () {
              context.push(
                const TrainerProfileScreen(
                  isTrainer: false,
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 15,
        ),
        itemCount: listArr.length,
      ),
    );
  }
}
