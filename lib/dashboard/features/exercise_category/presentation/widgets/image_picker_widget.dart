import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final String? networkImage;
  final VoidCallback onPickImage;

  const ImagePickerWidget({
    super.key,
    this.imageFile,
    this.networkImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageFile != null || networkImage != null)
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageFile != null
                  ? Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      networkImage!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 50,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ElevatedButton.icon(
          onPressed: onPickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: TColor.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
          label: Text(
            imageFile != null || networkImage != null
                ? 'تغيير الصورة'
                : 'اختيار صورة',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
} 