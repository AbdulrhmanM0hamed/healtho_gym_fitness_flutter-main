import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healtho_gym/common/color_extension.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final String? networkImage;
  final Function(File) onPickImage;

  const ImagePickerWidget({
    super.key,
    this.imageFile,
    this.networkImage,
    required this.onPickImage,
  });

  static Future<List<File>> pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      return pickedFiles.map((e) => File(e.path)).toList();
    }
    return [];
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onPickImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          image: (imageFile != null)
              ? DecorationImage(
                  image: FileImage(imageFile!),
                  fit: BoxFit.cover,
                )
              : (networkImage != null)
                  ? DecorationImage(
                      image: NetworkImage(networkImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
        ),
        child: (imageFile == null && networkImage == null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 48,
                    color: TColor.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختيار صورة',
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
} 