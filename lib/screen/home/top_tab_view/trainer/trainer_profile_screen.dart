import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/title_subtitle_button.dart';
import 'package:healtho_gym/screen/home/setting/setting_row.dart';

class TrainerProfileScreen extends StatefulWidget {
  final bool isTrainer;
  const TrainerProfileScreen({super.key, this.isTrainer = true});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/img/t_profile.png",
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
                      "Specialization in Fitness",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundButton(
                            title: "Follow",
                            height: 35,
                            radius: 10,
                            isPadding: false,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: RoundButton(
                            title: "Contact",
                            height: 35,
                            radius: 10,
                            isPadding: false,
                            onPressed: () {},
                          ),
                        )
                      ],
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "4/5",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Ratings",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 2,
                  height: 45,
                  color: TColor.board,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "78",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Following",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 2,
                  height: 45,
                  color: TColor.board,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "5667",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Follower",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    "assets/img/color_fb.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    "assets/img/tw.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    "assets/img/in.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    "assets/img/yt.png",
                    width: 25,
                    height: 25,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: TColor.board,
              height: 1,
            ),
          ),
          TitleSubtitleButton(
              title: "Certifications",
              subtitle: "Advance Trainer Certification ISSA",
              onPressed: () {}),
          TitleSubtitleButton(
              title: "Awards",
              subtitle: "Best in Muscle Building",
              onPressed: () {}),
          TitleSubtitleButton(
              title: "Publish Articles",
              subtitle: "Why Breathing is necessary while Gyming",
              onPressed: () {}),
          TitleSubtitleButton(
              title: "Conferences and Expos Attended",
              subtitle: "ISSA 2019",
              onPressed: () {}),
          TitleSubtitleButton(
              title: widget.isTrainer
                  ? "Personal Training Client and Feedback"
                  : "Feedback",
              subtitle: "Strict, Calm in Nature",
              onPressed: () {}),
        ],
      ),
    );
  }
}
