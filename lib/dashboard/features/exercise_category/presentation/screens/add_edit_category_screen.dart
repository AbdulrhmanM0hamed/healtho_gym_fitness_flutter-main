import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/models/exercise_category_model.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/widgets/image_picker_widget.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/widgets/custom_text_field.dart';

class AddEditCategoryScreen extends StatefulWidget {
  final ExerciseCategory? category;

  const AddEditCategoryScreen({
    super.key,
    this.category,
  });

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleArController = TextEditingController();
  final _titleController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  late ExerciseCategoryCubit _categoryCubit;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    // تهيئة الـ cubit في initState للتأكد من توفره قبل استخدامه
    _categoryCubit = sl<ExerciseCategoryCubit>();
    
    if (_isEditing) {
      _titleArController.text = widget.category!.titleAr;
      _titleController.text = widget.category!.title;
    }
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleController.dispose();
    // لا نحتاج إلى إغلاق _categoryCubit هنا لأنه يتم إدارته بواسطة service locator
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isEditing && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار صورة للفئة')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // استخدام الـ cubit الذي تم تهيئته في initState
      if (_isEditing) {
        await _categoryCubit.updateCategory(
          widget.category!.copyWith(
            titleAr: _titleArController.text,
            title: _titleController.text,
          ),
          image: _imageFile,
        );
      } else {
        await _categoryCubit.addCategory(
          titleAr: _titleArController.text,
          title: _titleController.text,
          image: _imageFile!,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoryCubit, // استخدام الـ cubit الموجود بدلاً من إنشاء واحد جديد
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          title: _isEditing ? 'تعديل الفئة' : 'إضافة فئة جديدة',
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
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
                            label: 'العنوان بالعربية',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال العنوان بالعربية';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _titleController,
                            label: 'العنوان بالإنجليزية',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال العنوان بالإنجليزية';
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
                            imageFile: _imageFile,
                            networkImage:
                                _isEditing ? widget.category?.imageUrl : null,
                            onPickImage: _pickImage,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isEditing ? 'حفظ التغييرات' : 'إضافة الفئة',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
