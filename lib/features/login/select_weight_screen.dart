import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/radio_button.dart';

class SelectWeightScreen extends StatefulWidget {
  final Function(dynamic) didChange;
  const SelectWeightScreen({super.key, required this.didChange});

  @override
  State<SelectWeightScreen> createState() => _SelectWeightScreenState();
}

class _SelectWeightScreenState extends State<SelectWeightScreen> {
  List valueArr = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var i = 35; i < 150; i++) {
      valueArr.add({"name": "$i KG", "value": i});
    }
  }

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
              "Select your Weight",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (value) {
                        widget.didChange(valueArr[value]["name"]);
                      },
                      children: List<Widget>.generate(valueArr.length, (index) {
                        var obj = valueArr[index];

                        return Text("${obj["name"]}");
                      }),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
