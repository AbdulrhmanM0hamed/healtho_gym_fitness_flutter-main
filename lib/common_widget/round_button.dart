import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

enum RoundButtonType { primary, line }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;
  final String? image;
  final bool isPadding;
  final double radius;
  final VoidCallback onPressed;
  const RoundButton(
      {super.key,
      required this.title,
      this.type = RoundButtonType.primary,
      this.height = 50,
      this.fontSize = 14,
      this.radius = 25,
      this.fontWeight = FontWeight.w600,
      this.width = double.maxFinite,
      this.isPadding = true,
      required this.onPressed, this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
       borderRadius: BorderRadius.circular(25),
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isPadding ? 20 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: width,
        decoration: BoxDecoration(
            color:
                type == RoundButtonType.primary ? TColor.primary : TColor.txtBG,
            border: type == RoundButtonType.line
                ? Border.all(color: TColor.board)
                : null,
            borderRadius: BorderRadius.circular(radius)),
        height: height,
        child: Row(
          children: [
            if(image != null) 
            SizedBox(
              width: 60,
              child: Image.asset(image!, width: 20, height: 20,),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: type == RoundButtonType.primary
                        ? TColor.btnPrimaryText
                        : TColor.btnSecondaryText,
                    fontSize: fontSize,
                    fontWeight: fontWeight),
              ),
            ),
             if(image != null) 
             Container(
              width: 60,
             )
          ],
        ),
      ),
    );
  }
}

class RoundSelectButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;
  final String? image;
  final bool isPadding;
  final VoidCallback onPressed;
  const RoundSelectButton(
      {super.key,
      required this.title,
      this.type = RoundButtonType.primary,
      this.height = 50,
      this.fontSize = 14,
      this.fontWeight = FontWeight.w600,
      this.width = double.maxFinite,
      this.isPadding = true,
      required this.onPressed,
      this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
       borderRadius: BorderRadius.circular(25),
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isPadding ? 20 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: width,
        decoration: BoxDecoration(
            color:
                type == RoundButtonType.primary ? TColor.primary : TColor.txtBG,
            border: type == RoundButtonType.line
                ? Border.all(color: TColor.board)
                : null,
            borderRadius: BorderRadius.circular(25)),
        height: height,
        child: Row(
          children: [
            if (image != null)
              SizedBox(
                width: 60,
                child: Image.asset(
                  image!,
                  width: 20,
                  height: 20,
                ),
              ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: type == RoundButtonType.primary
                        ? TColor.btnPrimaryText
                        : TColor.btnSecondaryText,
                    fontSize: fontSize,
                    fontWeight: fontWeight),
              ),
            ),
            if (image != null)
              Container(
                width: 60,
              )
          ],
        ),
      ),
    );
  }
}
