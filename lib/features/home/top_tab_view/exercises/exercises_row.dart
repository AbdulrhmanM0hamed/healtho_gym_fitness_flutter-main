import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ExercisesRow extends StatelessWidget {
  final Map obj;
  final VoidCallback onPressed;

  const ExercisesRow({super.key, required this.obj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: TColor.txtBG,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: 2 / 1,
                child: Image.asset(
                  obj["image"],
                  width: double.maxFinite,
                  height: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  width: context.width * 0.4,
                  height: 45,
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    obj["title"],
                    maxLines: 1,
                    style: TextStyle(
                      color: TColor.btnPrimaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 40,
                    child: Image.asset(
                      "assets/img/fav_white.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 40,
                    child: Image.asset(
                      "assets/img/share_white.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),

                const SizedBox(width: 8,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
