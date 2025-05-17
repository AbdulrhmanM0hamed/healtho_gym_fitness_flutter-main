import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class RoundDropDown extends StatelessWidget {
  final String hintText;
  final List list;
  final dynamic value;
  final bool isPadding;
  final Function(dynamic)? didChange;

  const RoundDropDown({
    super.key,
    required this.hintText,
    required this.list,
    this.value,
    this.isPadding = false,
    this.didChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: isPadding ? 20 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: TColor.txtBG,
          border: Border.all(color: TColor.board, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: value,
          icon: Image.asset(
            "assets/img/down.png",
            width: 15,
          ),
          hint: Text(
            hintText,
            style: TextStyle(color: TColor.secondaryText, fontSize: 15),
          ),
          items: list
              .map(
                (obj) => DropdownMenuItem(
                  value: obj,
                  child: Text(
                    obj["name"] as String? ?? "",
                    style: TextStyle(
                      color: TColor.primaryText,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: didChange,
        ),
      ),
    );
  }
}
