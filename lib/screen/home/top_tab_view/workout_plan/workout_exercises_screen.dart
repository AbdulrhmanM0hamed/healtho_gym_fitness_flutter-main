import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class WorkoutExercisesDetailScreen extends StatefulWidget {
  const WorkoutExercisesDetailScreen({super.key});

  @override
  State<WorkoutExercisesDetailScreen> createState() =>
      _WorkoutExercisesDetailScreenState();
}

class _WorkoutExercisesDetailScreenState
    extends State<WorkoutExercisesDetailScreen> {
  List imageArr = [
    "assets/img/ed_1.png",
    "assets/img/ed_2.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        centerTitle: false,
        title: const Text(
          "Bench Press",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.width * 0.4 + 40,
              child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return  ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          imageArr[index],
                          width: context.width * 0.7,
                          height: context.width * 0.4,
                          fit: BoxFit.cover,
                        ),
                      
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        width: 20,
                      ),
                  itemCount: imageArr.length),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bench Press",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "1) Lie back on a flat bench. Using a medium width grip, lift the bar from the rack and hold it straight over you with your arms locked. This will be your starting position. ",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "2) From the starting position, breathe in and begin coming down slowly until the bar touches your middle chest.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "3) After a brief pause, push the bar back to the starting position as you breathe out.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Equipment Required",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Barbell, Bench , Plate, Lock",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Target Muscle",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Chest, Shoulder, Triceps",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
              ),
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/img/fav_color.png",
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/img/share.png",
                width: 25,
                height: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
