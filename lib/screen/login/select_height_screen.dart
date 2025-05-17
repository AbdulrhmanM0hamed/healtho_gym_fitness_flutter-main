import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/radio_button.dart';

class SelectHeightScreen extends StatefulWidget {
  final Function(dynamic) didChange;
  const SelectHeightScreen({super.key, required this.didChange});

  @override
  State<SelectHeightScreen> createState() => _SelectHeightScreenState();
}

class _SelectHeightScreenState extends State<SelectHeightScreen> {
  List valueFtArr = [];
  List valueInchArr = [];

  int selectFt = 0;
  int selectInch = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var i = 2; i < 11; i++) {
      valueFtArr.add({"name": "$i Ft", "value": i});
    }

    for (var i = 0; i < 12; i++) {
      valueInchArr.add({"name": "$i Inch", "value": i});
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
              "Select your Height",
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
                        selectFt = value;
                        widget.didChange({
                          "ft": valueFtArr[selectFt]["name"],
                          "inch": valueInchArr[selectInch]["name"],
                        });
                      },
                      children:
                          List<Widget>.generate(valueFtArr.length, (index) {
                        var obj = valueFtArr[index];

                        return Text("${obj["name"]}");
                      }),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (value) {
                        selectInch = value;
                        widget.didChange({
                          "ft": valueFtArr[selectFt]["name"],
                          "inch": valueInchArr[selectInch]["name"],
                        });
                      },
                      children:
                          List<Widget>.generate(valueFtArr.length, (index) {
                        var obj = valueInchArr[index];

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
