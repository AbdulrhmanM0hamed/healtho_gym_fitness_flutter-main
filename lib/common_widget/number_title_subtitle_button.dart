import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class NumberTitleSubtitleButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;
  final VoidCallback onPressed;

  const NumberTitleSubtitleButton(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.number,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          decoration: BoxDecoration(
              color: TColor.txtBG,
              border: Border.all(color: TColor.board, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      number,
                      style: TextStyle(
                        color: TColor.placeholder,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            subtitle,
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "assets/img/next.png",
                width: 10,
                color: TColor.secondaryText,
              )
            ],
          ),
        ),
      ),
    );
  }
}
