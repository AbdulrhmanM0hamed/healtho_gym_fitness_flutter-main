import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healtho_gym/common/color_extension.dart';

class TrainerRow extends StatelessWidget {
  final Map obj;
  final VoidCallback onPressed;
  const TrainerRow({super.key, required this.obj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
            color: TColor.txtBG,
            border: Border.all(color: TColor.board, width: 1),
            borderRadius: BorderRadius.circular(
              15,
            )),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                obj["image"],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  obj["name"],
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  obj["detail"],
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: IgnorePointer(
                        ignoring: true,
                        child: RatingBar.builder(
                          initialRating: obj["rate"],
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 15,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/img/location.png",
                      width: 10,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      obj["location"],
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
