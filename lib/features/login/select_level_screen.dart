import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/radio_button.dart';

class SelectLevelScreen extends StatefulWidget {
  final Function(dynamic) didChange;
  const SelectLevelScreen({super.key, required this.didChange});

  @override
  State<SelectLevelScreen> createState() => _SelectLevelScreenState();
}

class _SelectLevelScreenState extends State<SelectLevelScreen> {
  int selectType = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height,
      color: Colors.black45,
      alignment: Alignment.center,
      child: Container(
        width: context.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select your Level",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            RadioButton(
                title: "Beginner",
                isSelect: selectType == 0,
                onPressed: () {
                  setState(() {
                    selectType = 0;
                  });
                  widget.didChange("Beginner");
                }),
            RadioButton(
                title: "Intermediate",
                isSelect: selectType == 1,
                onPressed: () {
                  setState(() {
                    selectType = 1;
                  });
                  widget.didChange("Intermediate");
                }),
            RadioButton(
                title: "Advance",
                isSelect: selectType == 2,
                onPressed: () {
                  setState(() {
                    selectType = 2;
                  });
                  widget.didChange("Advance");
                })
          ],
        ),
      ),
    );
  }
}
