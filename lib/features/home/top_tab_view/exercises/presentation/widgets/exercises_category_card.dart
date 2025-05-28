import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';

class ExercisesCategoryCard extends StatelessWidget {
  final ExerciseCategory category;
  final VoidCallback onPressed;

  const ExercisesCategoryCard({
    super.key, 
    required this.category, 
    required this.onPressed
  });

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
              child: _buildImage(category.imageUrl),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.titleAr,
                    maxLines: 1,
                    style: TextStyle(
                      color: TColor.btnPrimaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                   Text(
                    "${category.exercisesCount} تمرين",
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

  Widget _buildImage(String imagePath) {
    // Check if the image path is a network URL or local asset
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // It's a network image
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: double.maxFinite,
        height: double.maxFinite,
        fit: BoxFit.fill,
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 150),
        memCacheWidth: 500, 
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: TColor.primary,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported, size: 40),
        ),
      );
    } else {
      // It's a local asset
      return Image.asset(
        imagePath,
        width: double.maxFinite,
        height: double.maxFinite,
        fit: BoxFit.fill,
        cacheWidth: 500, 
      );
    }
  }
}
