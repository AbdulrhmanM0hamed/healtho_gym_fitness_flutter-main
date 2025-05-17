import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ExercisesCell extends StatelessWidget {
  final Map obj;
  final VoidCallback onPressed;

  const ExercisesCell({super.key, required this.obj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: TColor.txtBG,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)]),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                obj["image"],
                width: double.maxFinite,
                height: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    obj["title"],
                    maxLines: 1,
                    style: TextStyle(
                      color: TColor.btnPrimaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                   Text(
                    obj["subtitle"],
                    maxLines: 1,
                    style: TextStyle(
                      color: TColor.btnPrimaryText,
                      fontSize: 10,
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
