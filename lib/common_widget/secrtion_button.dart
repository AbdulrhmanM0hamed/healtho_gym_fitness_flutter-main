import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class SectionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SectionButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "More",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
