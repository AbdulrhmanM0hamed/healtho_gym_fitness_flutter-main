import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class SettingRow extends StatelessWidget {
  final String title;
  final String icon;
  final String value;
  final bool isIconCircle;
  final VoidCallback onPressed;

  const SettingRow({
    super.key,
    required this.title,
    required this.icon,
    this.value = "",
    this.isIconCircle = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: TColor.txtBG,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(isIconCircle ? 15 : 0),
              child: Image.asset(
                icon,
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              value,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
