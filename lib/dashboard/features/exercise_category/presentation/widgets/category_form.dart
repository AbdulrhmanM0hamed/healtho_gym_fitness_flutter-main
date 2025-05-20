import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common/widgets/custom_text_field.dart';
import 'package:healtho_gym/common/widgets/image_picker_widget.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/models/exercise_category_model.dart';

class CategoryForm extends StatefulWidget {
  final ExerciseCategory? category;
  final Function(String titleAr, String title) onSave;
  final Function(File image) onImagePicked;

  const CategoryForm({
    super.key,
    this.category,
    required this.onSave,
    required this.onImagePicked,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleArController = TextEditingController();
  final _titleController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _titleArController.text = widget.category!.titleAr;
      _titleController.text = widget.category!.title;
    }
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _titleArController.text,
        _titleController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'معلومات الفئة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _titleArController,
                    label: 'اسم الفئة بالعربية',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم الفئة بالعربية';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _titleController,
                    label: 'اسم الفئة بالإنجليزية',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم الفئة بالإنجليزية';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'صورة الفئة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ImagePickerWidget(
                    imageFile: _image,
                    networkImage: widget.category?.imageUrl,
                    onPickImage: (File image) {
                      setState(() {
                        _image = image;
                      });
                      widget.onImagePicked(image);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.category != null ? 'حفظ التغييرات' : 'إضافة الفئة',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 