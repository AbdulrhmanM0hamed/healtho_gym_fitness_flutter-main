import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healtho_gym/core/services/storage_service.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_plan_model.dart';

/// نموذج إضافة/تعديل خطة تمرين
class DashboardWorkoutPlanForm extends StatefulWidget {
  final DashboardWorkoutPlanModel? plan;
  final Function(DashboardWorkoutPlanModel) onSubmit;

  const DashboardWorkoutPlanForm({
    Key? key,
    this.plan,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<DashboardWorkoutPlanForm> createState() => _DashboardWorkoutPlanFormState();
}

class _DashboardWorkoutPlanFormState extends State<DashboardWorkoutPlanForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _goalController;
  int _categoryId = 1;
  int _durationWeeks = 4;
  String _level = 'beginner';
  int _daysPerWeek = 3;
  String _targetGender = 'All';
  bool _isFeatured = false;
  
  // إضافة متغيرات للصورة
  XFile? _selectedImage;
  String? _currentImageUrl;
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = sl<StorageService>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.plan?.title ?? '');
    _descriptionController = TextEditingController(text: widget.plan?.description ?? '');
    _goalController = TextEditingController(text: widget.plan?.goal ?? '');
    
    // حفظ رابط الصورة الحالية إذا كانت موجودة
    _currentImageUrl = widget.plan?.mainImageUrl;
    _categoryId = widget.plan?.categoryId ?? 1;
    _durationWeeks = widget.plan?.durationWeeks ?? 4;
    // تحويل قيمة المستوى إلى القيم المستخدمة في واجهة المستخدم
    if (widget.plan != null) {
      switch (widget.plan!.level) {
        case 'محترف':
          _level = 'expert';
          break;
        case 'متقدم':
          _level = 'advanced';
          break;
        case 'متوسط':
          _level = 'intermediate';
          break;
        default:
          _level = 'beginner';
      }
    } else {
      _level = 'beginner';
    }
    _daysPerWeek = widget.plan?.daysPerWeek ?? 3;
    // تحويل قيمة targetGender إلى القيم المستخدمة في واجهة المستخدم
    if (widget.plan != null) {
      switch (widget.plan!.targetGender) {
        case 'Male':
          _targetGender = 'Male';
          break;
        case 'Female':
          _targetGender = 'Female';
          break;
        default:
          _targetGender = 'All';
      }
    } else {
      _targetGender = 'All';
    }
    _isFeatured = widget.plan?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.plan == null ? 'إضافة خطة تمرين جديدة' : 'تعديل خطة التمرين',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان الخطة *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان للخطة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف الخطة',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // اختيار صورة من الجهاز
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('صورة الخطة *', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // عرض معاينة للصورة
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _getImageWidget(),
                      ),
                      const SizedBox(width: 16),
                      // أزرار اختيار الصورة
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickImageFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('اختيار من المعرض'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _pickImageFromCamera,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('التقاط صورة'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // رسالة خطأ إذا لم يتم اختيار صورة
                  if (_selectedImage == null && _currentImageUrl == null)
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'يرجى اختيار صورة للخطة',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: 'هدف الخطة *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال هدف الخطة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _categoryId,
                      decoration: const InputDecoration(
                        labelText: 'الفئة *',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<int>(value: 1, child: Text('بناء العضلات')),
                        DropdownMenuItem<int>(value: 2, child: Text('خسارة الوزن')),
                        DropdownMenuItem<int>(value: 3, child: Text('اللياقة البدنية')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _categoryId = value ?? 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _durationWeeks,
                      decoration: const InputDecoration(
                        labelText: 'مدة الخطة (بالأسابيع) *',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(12, (index) => index + 1)
                          .map((weeks) => DropdownMenuItem<int>(
                                value: weeks,
                                child: Text('$weeks أسبوع'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _durationWeeks = value ?? 4;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _daysPerWeek,
                      decoration: const InputDecoration(
                        labelText: 'أيام في الأسبوع *',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(7, (index) => index + 1)
                          .map((days) => DropdownMenuItem<int>(
                                value: days,
                                child: Text('$days يوم'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _daysPerWeek = value ?? 3;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _level,
                      decoration: const InputDecoration(
                        labelText: 'مستوى الخطة *',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<String>(value: 'beginner', child: Text('مبتدئ')),
                        DropdownMenuItem<String>(value: 'intermediate', child: Text('متوسط')),
                        DropdownMenuItem<String>(value: 'advanced', child: Text('متقدم')),
                        DropdownMenuItem<String>(value: 'expert', child: Text('محترف')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _level = value ?? 'beginner';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _targetGender,
                      decoration: const InputDecoration(
                        labelText: 'الجنس المستهدف *',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<String>(value: 'All', child: Text('الجميع')),
                        DropdownMenuItem<String>(value: 'Male', child: Text('ذكور')),
                        DropdownMenuItem<String>(value: 'Female', child: Text('إناث')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _targetGender = value ?? 'All';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isFeatured,
                    onChanged: (value) {
                      setState(() {
                        _isFeatured = value ?? false;
                      });
                    },
                  ),
                  const Text('خطة مميزة'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(widget.plan == null ? 'إضافة' : 'تحديث'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  // دالة لتحويل قيمة المستوى من القيم المستخدمة في واجهة المستخدم إلى القيم المستخدمة في قاعدة البيانات
  String _getLevelText(String level) {
    switch (level) {
      case 'beginner':
        return 'مبتدئ';
      case 'intermediate':
        return 'متوسط';
      case 'advanced':
        return 'متقدم';
      case 'expert':
        return 'محترف';
      default:
        return 'مبتدئ';
    }
  }

  // دالة لاختيار صورة من المعرض
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  // دالة لالتقاط صورة من الكاميرا
  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  // دالة لعرض الصورة المختارة أو الحالية
  Widget _getImageWidget() {
    if (_selectedImage != null) {
      // عرض الصورة المختارة من الجهاز
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(_selectedImage!.path),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
      );
    } else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      // عرض الصورة الحالية من الرابط
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          _currentImageUrl!,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.error, color: Colors.red),
            );
          },
        ),
      );
    } else {
      // عرض أيقونة إذا لم يتم اختيار صورة
      return const Center(
        child: Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
      );
    }
  }

  // دالة للتحقق من صحة النموذج
  bool _validateForm() {
    bool isValid = _formKey.currentState!.validate();
    
    // التحقق من وجود صورة
    if (_selectedImage == null && (_currentImageUrl == null || _currentImageUrl!.isEmpty)) {
      setState(() {}); // لتحديث واجهة المستخدم وإظهار رسالة الخطأ
      isValid = false;
    }
    
    return isValid;
  }

  Future<void> _submitForm() async {
    if (_validateForm()) {
      // عرض مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        String imageUrl = _currentImageUrl ?? '';
        
        // رفع الصورة الجديدة إذا تم اختيارها
        if (_selectedImage != null) {
          final planId = widget.plan?.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
          imageUrl = await _storageService.uploadWorkoutPlanImage(_selectedImage!, planId);
        }
        
        final plan = DashboardWorkoutPlanModel(
          id: widget.plan?.id,
          categoryId: _categoryId,
          title: _titleController.text,
          description: _descriptionController.text,
          mainImageUrl: imageUrl,
          goal: _goalController.text,
          durationWeeks: _durationWeeks,
          // تحويل قيمة المستوى إلى القيم المستخدمة في قاعدة البيانات
          level: _getLevelText(_level),
          daysPerWeek: _daysPerWeek,
          targetGender: _targetGender,
          isFeatured: _isFeatured,
          createdAt: widget.plan?.createdAt,
          updatedAt: DateTime.now(),
        );
        
        // إغلاق مؤشر التحميل
        Navigator.pop(context);
        
        widget.onSubmit(plan);
      } catch (e) {
        // إغلاق مؤشر التحميل وعرض رسالة الخطأ
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء رفع الصورة: $e')),
        );
      }
    }
  }
}
