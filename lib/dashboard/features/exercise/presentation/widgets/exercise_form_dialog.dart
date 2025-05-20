import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/services/storage_service.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/models/exercise_model.dart';
import 'package:healtho_gym/core/di/service_locator.dart';

class ExerciseFormDialog extends StatefulWidget {
  final Exercise? exercise;
  final int categoryId;
  final Function(String title, String description, File mainImage, List<File> images, int level) onAdd;
  final Function(Exercise exercise, File? mainImage, List<File>? images) onEdit;

  const ExerciseFormDialog({
    super.key,
    this.exercise,
    required this.categoryId,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  State<ExerciseFormDialog> createState() => _ExerciseFormDialogState();
}

class _ExerciseFormDialogState extends State<ExerciseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _storageService = sl<StorageService>();
  
  File? _mainImage;
  List<File> _images = [];
  int _selectedLevel = 1;
  bool _isLoading = false;

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

  Future<void> _pickMainImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _mainImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في اختيار الصورة')),
      );
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _images.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في اختيار الصور')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.exercise == null ? 'إضافة تمرين جديد' : 'تعديل التمرين'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'عنوان التمرين'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال عنوان التمرين';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'وصف التمرين'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال وصف التمرين';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Main Image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الصورة الرئيسية'),
                  const SizedBox(height: 8),
                  if (_mainImage != null)
                    Stack(
                      children: [
                        Image.file(_mainImage!, height: 100),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => _mainImage = null),
                          ),
                        ),
                      ],
                    )
                  else if (widget.exercise != null)
                    Stack(
                      children: [
                        Image.network(widget.exercise!.mainImageUrl, height: 100),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _pickMainImage,
                          ),
                        ),
                      ],
                    ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('اختر الصورة الرئيسية'),
                    onPressed: _pickMainImage,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Additional Images
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('صور إضافية'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._images.asMap().entries.map((entry) {
                        return Stack(
                          children: [
                            Image.file(entry.value, height: 80, width: 80, fit: BoxFit.cover),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _removeImage(entry.key),
                              ),
                            ),
                          ],
                        );
                      }),
                      if (widget.exercise != null)
                        ...widget.exercise!.imageUrl.map((url) {
                          return Stack(
                            children: [
                              Image.network(url, height: 80, width: 80, fit: BoxFit.cover),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: _pickImages,
                                ),
                              ),
                            ],
                          );
                        }),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('أضف صور'),
                    onPressed: _pickImages,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedLevel,
                decoration: const InputDecoration(labelText: 'المستوى'),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        if (_isLoading)
          const CircularProgressIndicator()
        else
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (widget.exercise == null && _mainImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء اختيار الصورة الرئيسية')),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                try {
                  if (widget.exercise == null) {
                    await widget.onAdd(
                      _titleController.text,
                      _descriptionController.text,
                      _mainImage!,
                      _images,
                      _selectedLevel,
                    );
                  } else {
                    await widget.onEdit(
                      widget.exercise!,
                      _mainImage,
                      _images.isNotEmpty ? _images : null,
                    );
                  }
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('حدث خطأ: $e')),
                  );
                } finally {
                  setState(() => _isLoading = false);
                }
              }
            },
            child: Text(widget.exercise == null ? 'إضافة' : 'حفظ'),
          ),
      ],
    );
  }
} 