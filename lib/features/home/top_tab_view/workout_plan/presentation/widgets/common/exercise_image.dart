import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExerciseImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ExerciseImage({
    Key? key,
    required this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    // Check if the image is a URL or an asset path
    if (imageUrl.startsWith('http')) {
      // It's a URL, use CachedNetworkImage
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) {
          print('Error loading image: $url, Error: $error');
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      // It's an asset path, use Image.asset
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(
              Icons.broken_image,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }
} 