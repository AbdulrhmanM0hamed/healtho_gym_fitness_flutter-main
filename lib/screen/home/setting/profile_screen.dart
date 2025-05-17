import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/setting/setting_row.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Image.asset(
              "assets/img/back.png",
              width: 18,
              height: 18,
            )),
        title: Text(
          "Profile",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/img/user_placeholder.png",
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ashish Chutake",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "7894561230",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "codeforany@gmail.com",
                      style: TextStyle(color: TColor.primaryText, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/img/location.png",
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Mumbai",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
          SettingRow(
              title: "Complete Task",
              icon: "assets/img/completed_tasks.png",
              value: "3",
              onPressed: () {}),
          SettingRow(
              title: "Level",
              icon: "assets/img/level.png",
              value: "Beginner",
              onPressed: () {}),
          SettingRow(
              title: "Goals",
              icon: "assets/img/goal.png",
              value: "Mass Gain",
              onPressed: () {}),
          SettingRow(
              title: "Challenges",
              icon: "assets/img/challenges.png",
              value: "4",
              onPressed: () {}),
          SettingRow(
              title: "Plans",
              icon: "assets/img/calendar.png",
              value: "2",
              onPressed: () {}),
          SettingRow(
              title: "Fitness Device",
              icon: "assets/img/smartwatch.png",
              value: "Mi",
              onPressed: () {}),
          SettingRow(
              title: "Refer a Friend",
              icon: "assets/img/share.png",
              value: "",
              onPressed: () {}),
        ],
      ),
    );
  }
}
