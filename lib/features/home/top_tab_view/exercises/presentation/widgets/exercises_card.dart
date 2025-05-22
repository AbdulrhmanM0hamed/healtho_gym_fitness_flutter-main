import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';

class ExercisesCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onPressed;
  final VoidCallback onToggleFavorite;

  const ExercisesCard({
    super.key, 
    required this.exercise,
    required this.onPressed,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    bool isFavorite = exercise.isFavorite;
    
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
                child: _buildImage(exercise.mainImageUrl),
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
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    exercise.title,
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
                  onTap: onToggleFavorite,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 25,
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
  
  Widget _buildImage(String imagePath) {
    // Safety check for empty path
    if (imagePath.isEmpty) {
      return Container(
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported, size: 40),
      );
    }
    
    // Check if the image path is a network URL or local asset
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // It's a network image
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: double.maxFinite,
        height: double.maxFinite,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: TColor.primary,
          ),
        ),
        errorWidget: (context, url, error) {
          print('DEBUG: Error loading image in card: $url, Error: $error');
          return Container(
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Icon(Icons.image_not_supported, size: 40),
          );
        },
      );
    } else {
      // It's a local asset
      try {
        return Image.asset(
          imagePath,
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('DEBUG: Error loading local image: $imagePath, Error: $error');
            return Container(
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported, size: 40),
            );
          },
        );
      } catch (e) {
        print('DEBUG: Exception loading image: $e');
        return Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported, size: 40),
        );
      }
    }
  }
}
