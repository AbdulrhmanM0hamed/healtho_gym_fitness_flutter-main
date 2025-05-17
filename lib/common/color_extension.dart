import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xffF1C40E);
  static Color get secondary => const Color(0xff102B46);

  static Color get primaryText => const Color(0xff0C0B0B);
  static Color get secondaryText => const Color(0xff2C3E50);
  static Color get btnPrimaryText => const Color(0xff0D0C0C);
  static Color get btnSecondaryText => const Color(0xff241111);
  static Color get board => const Color(0xffD4D4D4);
  static Color get txtBG => const Color(0xffFCFBFB);
  static Color get btnBG => const Color(0xffF0F0F3);
  static Color get inactive => primaryText.withOpacity(0.2);
  static Color get placeholder => const Color(0xff94A5A6);
  static Color get textFieldBg => const Color(0xffF8F8F8);
  static Color get error => const Color(0xffE74C3C);
}

extension AppContext on BuildContext {
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  Future push(Widget widget) async {
    return Navigator.push(
        this, MaterialPageRoute(builder: (context) => widget));
  }

  Future pop() async {
    return Navigator.pop(this);
  }
}
