import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/screen/home/setting/setting_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/physique_screen.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {

  String selectName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Select Your Goal",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: ["Fat Loss", "Weight Gain", "Muscle Gain", "Others"]
                    .map((name) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundSelectButton(title: name, type: RoundButtonType.line, isPadding: false,
                    image: selectName == name ? "assets/img/radio_select.png" : "assets/img/radio_unselect.png" ,
                     onPressed: (){
                    
                      setState(() {
                        selectName = name;
                      });
                    
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(title: "DONE", isPadding: false, onPressed: () {
                context.push(const PhysiqueScreen());
              }),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
