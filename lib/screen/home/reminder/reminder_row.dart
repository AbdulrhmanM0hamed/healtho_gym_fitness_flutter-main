import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ReminderRow extends StatelessWidget {
  const ReminderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: TColor.txtBG,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TColor.board, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Workout Reminder",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: Switch(
                    value: true,
                    activeColor: TColor.primary,
                    onChanged: (newVal) {}),
              )
            ],
          ),
          Text(
            "06 : 00 AM",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                "Repeat",
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                " - ",
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: Text(
                  "Mon, Tue, Fri",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {},
                  child: Image.asset(
                    "assets/img/delete.png",
                    width: 25,
                    height: 25,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
