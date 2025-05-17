import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/round_title_value_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/select_age_screen.dart';
import 'package:healtho_gym/screen/login/select_height_screen.dart';
import 'package:healtho_gym/screen/login/select_level_screen.dart';
import 'package:healtho_gym/screen/login/select_weight_screen.dart';

class PhysiqueScreen extends StatefulWidget {
  const PhysiqueScreen({super.key});

  @override
  State<PhysiqueScreen> createState() => _PhysiqueScreenState();
}

class _PhysiqueScreenState extends State<PhysiqueScreen> {
  String selectAge = "19";
  String selectHeight = "6 Ft 4 Inch";
  String selectWeight = "78 KG";
  String selectLevel = "Beginner";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Enter Your Physique",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              RoundTitleValueButton(
                  title: "Age",
                  value: "$selectAge Yrs",
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return SelectAgeScreen(didChange: (val) {
                            setState(() {
                              selectAge = val;
                            });
                          });
                        });
                  }),
              RoundTitleValueButton(
                  title: "Height",
                  value: selectHeight,
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return SelectHeightScreen(didChange: (val) {
                            setState(() {
                              selectHeight = "${val["ft"]} ${val["inch"]}";
                            });
                          });
                        });
                  }),
              RoundTitleValueButton(
                  title: "Weight",
                  value: selectWeight,
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return SelectWeightScreen(didChange: (val) {
                            setState(() {
                              selectWeight = val;
                            });
                          });
                        });
                  }),
              RoundTitleValueButton(
                  title: "Level",
                  value: selectLevel,
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return SelectLevelScreen(didChange: (val) {
                            setState(() {
                              selectLevel = val;
                            });
                          });
                        });
                  }),
              const SizedBox(
                height: 40,
              ),

              RoundButton(title: "Confirm Detail", isPadding: false, onPressed: (){
                  context.push(const TopTabViewScreen() );
              })
            ],
          ),
        ),
      ),
    );
  }
}
