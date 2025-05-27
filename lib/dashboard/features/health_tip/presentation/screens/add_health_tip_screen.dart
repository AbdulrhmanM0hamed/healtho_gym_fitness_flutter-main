import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common/custom_app_bar.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/toast_helper.dart';
import 'package:image_picker/image_picker.dart';
import '../viewmodels/health_tip_cubit.dart';
import '../viewmodels/health_tip_state.dart';

class AddHealthTipScreen extends StatefulWidget {
  const AddHealthTipScreen({super.key});

  @override
  State<AddHealthTipScreen> createState() => _AddHealthTipScreenState();
}

class _AddHealthTipScreenState extends State<AddHealthTipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  
  bool _isFeatured = false;
  XFile? _pickedFile;
  String? _imageUrl;
  List<String> _tags = [];

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
          if (kIsWeb) {
            // For web, we'll just store the URL for preview
            _imageUrl = pickedFile.path;
          }
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ToastHelper.showFlushbar(
        context: context,
        title: 'خطأ',
        message: 'حدث خطأ أثناء اختيار الصورة: $e',
        type: ToastType.error,
      );
    }
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<HealthTipCubit>();
      
      bool success;
      
      if (_pickedFile != null) {
        // Add health tip with image
        success = await cubit.addHealthTipWithImage(
          title: _titleController.text,
          subtitle: _subtitleController.text,
          content: _contentController.text,
          imageFile: _pickedFile!,
          tags: _tags,
          isFeatured: _isFeatured,
        );
      } else {
        // Add health tip without image
        success = await cubit.addHealthTip(
          title: _titleController.text,
          subtitle: _subtitleController.text,
          content: _contentController.text,
          tags: _tags,
          isFeatured: _isFeatured,
        );
      }
      
      if (success && mounted) {
        // استخدام Future.delayed لتأخير العودة للشاشة السابقة حتى تكتمل عملية عرض الرسالة
        ToastHelper.showFlushbar(
          context: context,
          title: 'تمت العملية بنجاح',
          message: 'تم إضافة النصيحة وإرسال إشعار للمستخدمين بنجاح',
          type: ToastType.success,
          onDismissed: () {
            // العودة للشاشة السابقة بعد إغلاق الرسالة
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthTipCubit, HealthTipState>(
      listener: (context, state) {
        if (state.hasError) {
          ToastHelper.showFlushbar(
            context: context,
            title: 'خطأ',
            message: state.errorMessage,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar:const CustomAppBar(
            title: 'إضافة نصيحة جديدة',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Picker
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          image: _getImageProvider(),
                        ),
                        child: _pickedFile == null
                            ? const Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title Field
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Subtitle Field
                  TextFormField(
                    controller: _subtitleController,
                    decoration: const InputDecoration(
                      labelText: 'Subtitle',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subtitle';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Content Field
                  TextFormField(
                    controller: _contentController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter content';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tagController,
                          decoration: const InputDecoration(
                            labelText: 'Add Tags',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addTag,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.secondary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Add Tag'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        onDeleted: () => _removeTag(tag),
                        deleteIconColor: Colors.red,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Featured Checkbox
                  CheckboxListTile(
                    title: const Text('Featured'),
                    value: _isFeatured,
                    onChanged: (value) {
                      setState(() {
                        _isFeatured = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: state.isLoading
                      ? Container(
                          height: 50,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: TColor.primary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : RoundButton(
                          title: 'حفظ النصيحة',
                          onPressed: () => _submitForm(context),
                          type: RoundButtonType.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  DecorationImage? _getImageProvider() {
    if (_pickedFile == null) {
      return null;
    }
    
    if (kIsWeb) {
      // For web
      return DecorationImage(
        image: NetworkImage(_imageUrl!),
        fit: BoxFit.cover,
      );
    } else {
      // For mobile
      return DecorationImage(
        image: FileImage(io.File(_pickedFile!.path)),
        fit: BoxFit.cover,
      );
    }
  }
} 