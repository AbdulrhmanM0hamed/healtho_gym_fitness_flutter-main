import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class TitleSubtitleButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const TitleSubtitleButton(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: TColor.txtBG,
            border: Border.all(color: TColor.board, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
