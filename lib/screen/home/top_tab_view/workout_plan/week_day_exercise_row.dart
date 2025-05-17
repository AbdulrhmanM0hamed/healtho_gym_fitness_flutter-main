import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class WeekDayExerciseRow extends StatelessWidget {
  final Map obj;
  final VoidCallback onPressed;
  const WeekDayExerciseRow(
      {super.key, required this.obj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: TColor.txtBG,
            border: Border.all(
              color: TColor.board,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                obj["name"],
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            Expanded(
              child: (obj["is_rest"] as bool? ?? false)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "REST",
                          style: TextStyle(
                            color: TColor.placeholder,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "For The Muscle Recovery",
                          style: TextStyle(
                              color: TColor.primaryText, fontSize: 12),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total Exercise",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              obj["total"],
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Major Exercise",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              obj["major"],
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Minor Exercise",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              obj["minor"],
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 14,
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
              width: 10,
              color: TColor.placeholder,
            )
          ],
        ),
      ),
    );
  }
}
