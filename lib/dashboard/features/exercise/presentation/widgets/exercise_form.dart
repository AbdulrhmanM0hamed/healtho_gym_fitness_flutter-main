import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common/widgets/custom_text_field.dart';
import 'package:healtho_gym/common/widgets/image_picker_widget.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/models/exercise_model.dart';

class ExerciseForm extends StatefulWidget {
  final Exercise? exercise;
  final String categoryTitle;
  final Function(String title, String description, int level) onSave;
  final Function(File mainImage) onMainImagePicked;
  final Function(List<File> images) onAdditionalImagesPicked;

  const ExerciseForm({
    super.key,
    this.exercise,
    required this.categoryTitle,
    required this.onSave,
    required this.onMainImagePicked,
    required this.onAdditionalImagesPicked,
  });

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _mainImage;
  List<File> _images = [];
  int _selectedLevel = 1;

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      _titleController.text = widget.exercise!.title;
      _descriptionController.text = widget.exercise!.description;
      _selectedLevel = widget.exercise!.level;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _titleController.text,
        _descriptionController.text,
        _selectedLevel,
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
                  Text(
                    'فئة التمرين: ${widget.categoryTitle}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _titleController,
                    label: 'عنوان التمرين',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال عنوان التمرين';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'وصف التمرين',
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال وصف التمرين';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedLevel,
                    decoration: InputDecoration(
                      labelText: 'مستوى التمرين',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: [1, 2, 3].map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text('المستوى $level'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLevel = value;
                        });
                      }
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
                    'الصورة الرئيسية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ImagePickerWidget(
                    imageFile: _mainImage,
                    networkImage: widget.exercise?.mainImageUrl,
                    onPickImage: (File image) {
                      setState(() {
                        _mainImage = image;
                      });
                      widget.onMainImagePicked(image);
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
                    'صور إضافية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(_images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (widget.exercise?.imageUrl.isNotEmpty ?? false)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_images.isEmpty) const SizedBox(height: 16),
                        const Text(
                          'الصور الحالية',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.exercise!.imageUrl.length,
                            itemBuilder: (context, index) {
                              final url = widget.exercise!.imageUrl[index].trim();
                              return Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final images = await ImagePickerWidget.pickMultipleImages();
                      if (images.isNotEmpty) {
                        setState(() {
                          _images = images;
                        });
                        widget.onAdditionalImagesPicked(images);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
                    label: Text(
                      _images.isNotEmpty ? 'تغيير الصور' : 'اختيار صور',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
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
              widget.exercise != null ? 'حفظ التغييرات' : 'إضافة التمرين',
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