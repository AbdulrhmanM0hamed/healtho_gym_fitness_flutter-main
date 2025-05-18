import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;
  final String refreshTimestamp;

  const ImagePreviewScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.id,
    required this.refreshTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    // إضافة طابع زمني للصورة لضمان تحديثها
    final updatedImageUrl = imageUrl + '?t=${DateTime.now().millisecondsSinceEpoch}';
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // يمكن إضافة وظيفة المشاركة هنا
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('جاري مشاركة الصورة...'),
                  backgroundColor: TColor.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            updatedImageUrl,
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained,
          heroAttributes: PhotoViewHeroAttributes(tag: "image_$id"), // استخدام نفس المعرف للـ hero
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                color: TColor.primary,
              ),
            ),
          ),
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }
} 