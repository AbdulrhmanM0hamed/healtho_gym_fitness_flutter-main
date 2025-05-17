import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class NotificationRow extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const NotificationRow(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: TColor.txtBG,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TColor.board, width: 1)),
        child: Text(
          title,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
