import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class HealthTipDetailScreen extends StatefulWidget {
  const HealthTipDetailScreen({super.key});

  @override
  State<HealthTipDetailScreen> createState() => _HealthTipDetailScreenState();
}

class _HealthTipDetailScreenState extends State<HealthTipDetailScreen> {
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
          "Health Tip",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/img/home_1.png",
                      width: double.maxFinite,
                      height: context.width * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "A Diet Without Exercise is Useless",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "1) Interval Training is a form of exercise in which you alternate between two or more different exercise . This Consist of doing an exercise at a very high  level intensity for a short bursts.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "2) Some high intensity interval training is a great way to burn calories and lose weight.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "3) Another great thing is about interval training is that it is extremely time efficient. It does not make any time to get into shape when you practice high intensity interval training.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "4) Exercise, especially high intensity interval training, is awesome because it keeps you younger for longer....",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "5) Interval Training is a form of exercise in which you alternate between two or more different exercise . This Consist of doing an exercise at a very high  level intensity for a short bursts.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "6) Some high intensity interval training is a great way to burn calories and lose weight.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "7) Another great thing is about interval training is that it is extremely time efficient. It does not make any time to get into shape when you practice high intensity interval training.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "8) Exercise, especially high intensity interval training, is awesome because it keeps you younger for longer….",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
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
                color: Colors.black26,
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
