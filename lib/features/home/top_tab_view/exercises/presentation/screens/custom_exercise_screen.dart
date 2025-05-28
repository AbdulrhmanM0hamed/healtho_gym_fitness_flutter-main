import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/theme/app_colors.dart';
import 'package:healtho_gym/common/custom_app_bar.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/custom_exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/custom_exercises_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/custom_exercises_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// شاشة تخصيص التمرين
class CustomExerciseScreen extends StatefulWidget {
  final Exercise originalExercise;
  final CustomExercise? customExercise;
  final bool isNewExercise;

  const CustomExerciseScreen({
    Key? key,
    required this.originalExercise,
    this.customExercise,
    this.isNewExercise = false,
  }) : super(key: key);

  @override
  State<CustomExerciseScreen> createState() => _CustomExerciseScreenState();
}

class _CustomExerciseScreenState extends State<CustomExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  late TextEditingController _setsController;
  late TextEditingController _notesController;
  
  XFile? _pickedImage;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    // تهيئة وحدات التحكم بالنص
    _titleController = TextEditingController(
      text: widget.customExercise?.title ?? widget.originalExercise.title
    );
    
    _descriptionController = TextEditingController(
      text: widget.customExercise?.description ?? widget.originalExercise.description
    );
    
    _weightController = TextEditingController(
      text: widget.customExercise?.lastWeight.toString() ?? '0'
    );
    
    _repsController = TextEditingController(
      text: widget.customExercise?.lastReps.toString() ?? '0'
    );
    
    _setsController = TextEditingController(
      text: widget.customExercise?.lastSets.toString() ?? '0'
    );
    
    _notesController = TextEditingController(
      text: widget.customExercise?.notes ?? ''
    );
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    
    // عرض خيارات اختيار الصورة
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('اختيار من المعرض'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  
                  if (pickedFile != null) {
                    setState(() {
                      _pickedImage = pickedFile;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('التقاط صورة بالكاميرا'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                  );
                  
                  if (pickedFile != null) {
                    setState(() {
                      _pickedImage = pickedFile;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _saveCustomExercise() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final cubit = context.read<CustomExercisesCubit>();
      
      if (widget.customExercise != null) {
        // تحديث تمرين مخصص موجود
        final updatedExercise = widget.customExercise!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          lastWeight: double.tryParse(_weightController.text) ?? 0,
          lastReps: int.tryParse(_repsController.text) ?? 0,
          lastSets: int.tryParse(_setsController.text) ?? 0,
          notes: _notesController.text,
          updatedAt: DateTime.now(),
        );
        
        await cubit.updateCustomExercise(updatedExercise);
        
        // تحديث الصورة إذا تم اختيار صورة جديدة
        if (_pickedImage != null) {
          await cubit.updateExerciseImage(updatedExercise.id, _pickedImage!);
        }
      } else if (widget.isNewExercise) {
        // إنشاء تمرين جديد تماماً
        await cubit.createNewCustomExercise(
          categoryId: widget.originalExercise.categoryId,
          title: _titleController.text,
          description: _descriptionController.text,
          level: widget.originalExercise.level,
          mainImageUrl: widget.originalExercise.mainImageUrl,
          imageUrl: widget.originalExercise.imageUrl,
          lastWeight: double.tryParse(_weightController.text) ?? 0,
          lastReps: int.tryParse(_repsController.text) ?? 0,
          lastSets: int.tryParse(_setsController.text) ?? 0,
          notes: _notesController.text,
        );
        
        // تحديث الصورة إذا تم اختيار صورة جديدة
        if (_pickedImage != null && cubit.state is CustomExerciseSaved) {
          final customExercise = (cubit.state as CustomExerciseSaved).customExercise;
          await cubit.updateExerciseImage(customExercise.id, _pickedImage!);
        }
      } else {
        // إنشاء تمرين مخصص من تمرين أصلي
        await cubit.createCustomExerciseFromOriginal(widget.originalExercise);
        
        // الحصول على التمرين المخصص الذي تم إنشاؤه
        if (cubit.state is CustomExerciseSaved) {
          final customExercise = (cubit.state as CustomExerciseSaved).customExercise;
          
          // تحديث التمرين المخصص بالبيانات المدخلة
          final updatedExercise = customExercise.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
            lastWeight: double.tryParse(_weightController.text) ?? 0,
            lastReps: int.tryParse(_repsController.text) ?? 0,
            lastSets: int.tryParse(_setsController.text) ?? 0,
            notes: _notesController.text,
            updatedAt: DateTime.now(),
          );
          
          await cubit.updateCustomExercise(updatedExercise);
          
          // تحديث الصورة إذا تم اختيار صورة جديدة
          if (_pickedImage != null) {
            await cubit.updateExerciseImage(updatedExercise.id, _pickedImage!);
          }
        }
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomExercisesCubit, CustomExercisesState>(
      listener: (context, state) {
        if (state is CustomExercisesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is CustomExerciseSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ التمرين بنجاح')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          title: widget.isNewExercise ? 'تمرين جديد' : 'تخصيص التمرين',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: AppColors.secondary,
          titleColor: AppColors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.save, color: AppColors.white),
              onPressed: _isLoading ? null : _saveCustomExercise,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // صورة التمرين
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: _buildExerciseImage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // عنوان التمرين
                      _buildTextField(
                        controller: _titleController,
                        label: 'عنوان التمرين',
                        icon: Icons.title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال عنوان التمرين';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // وصف التمرين
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'وصف التمرين',
                        icon: Icons.description,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال وصف التمرين';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // معلومات التمرين الشخصية
                      const Text(
                        'معلومات التمرين الشخصية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // الوزن الأخير
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.fitness_center, color: TColor.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'معلومات التمرين الشخصية',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _weightController,
                                    label: 'الوزن (كجم)',
                                    icon: Icons.fitness_center,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _repsController,
                                    label: 'التكرارات',
                                    icon: Icons.repeat,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _setsController,
                                    label: 'المجموعات',
                                    icon: Icons.format_list_numbered,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // ملاحظات شخصية
                      _buildTextField(
                        controller: _notesController,
                        label: 'ملاحظات شخصية',
                        icon: Icons.note,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      
                      // زر الحفظ
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveCustomExercise,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'حفظ التمرين المخصص',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: TColor.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: TColor.primary),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
  
  Widget _buildExerciseImage() {
    if (_pickedImage != null) {
      // إذا تم اختيار صورة جديدة
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(_pickedImage!.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (widget.customExercise?.localImagePath.isNotEmpty ?? false) {
      // إذا كان هناك صورة محلية للتمرين المخصص
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(widget.customExercise!.localImagePath),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else {
      // استخدام الصورة الأصلية من الإنترنت
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: widget.originalExercise.mainImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.image_not_supported,
                size: 50,
                color: Colors.grey,
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
