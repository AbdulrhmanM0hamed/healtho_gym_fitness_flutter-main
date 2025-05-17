import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class DayExerciseRow extends StatelessWidget {
  final Map obj;
  final VoidCallback onPressed;

  const DayExerciseRow({super.key, required this.obj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: TColor.txtBG,
          border: Border.all(color: TColor.board, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        obj["image"],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          obj["name"],
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                "Sets",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                obj["sets"],
                                style: TextStyle(
                                  color: TColor.placeholder,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                "Reps",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                obj["reps"],
                                style: TextStyle(
                                  color: TColor.placeholder,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                "Reset",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                obj["rest"],
                                style: TextStyle(
                                  color: TColor.placeholder,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Image.asset(
                    "assets/img/next.png",
                    width: 12,
                    color: TColor.placeholder,
                  )
                ],
              ),
            ),
            Container(
              color: TColor.board,
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    obj["is_complete"]
                        ? "assets/img/check_tick.png"
                        : "assets/img/uncheck.png",
                    width: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Mark as completed",
                    style: TextStyle(
                      color: obj["is_complete"]
                          ? const Color(0xff27AE60)
                          : TColor.placeholder,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
