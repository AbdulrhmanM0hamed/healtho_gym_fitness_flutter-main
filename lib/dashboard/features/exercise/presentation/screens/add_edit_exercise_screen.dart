import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/models/exercise_model.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/widgets/exercise_form.dart';

class AddEditExerciseScreen extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;
  final Exercise? exercise;

  const AddEditExerciseScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    this.exercise,
  });

  @override
  State<AddEditExerciseScreen> createState() => _AddEditExerciseScreenState();
}

class _AddEditExerciseScreenState extends State<AddEditExerciseScreen> {
  bool _isLoading = false;
  late final ExerciseCubit _exerciseCubit;
  File? _mainImage;
  List<File> _images = [];

  bool get _isEditing => widget.exercise != null;

  @override
  void initState() {
    super.initState();
    LoggerUtil.info('Initializing AddEditExerciseScreen');
    LoggerUtil.info('CategoryId: ${widget.categoryId}');
    LoggerUtil.info('CategoryTitle: ${widget.categoryTitle}');
    LoggerUtil.info('Is Editing: $_isEditing');

    _exerciseCubit = sl<ExerciseCubit>();
  }

  Future<void> _saveExercise(String title, String description, int level) async {
    setState(() => _isLoading = true);
    LoggerUtil.info('Started saving exercise');

    try {
      if (_isEditing) {
        LoggerUtil.info('Updating existing exercise');
        await _exerciseCubit.updateExercise(
          widget.exercise!,
          title: title,
          description: description,
          level: level,
          mainImage: _mainImage,
          images: _images.isNotEmpty ? _images : null,
        );
      } else {
        LoggerUtil.info('Adding new exercise');
        LoggerUtil.info('Title: $title');
        LoggerUtil.info('Description: $description');
        LoggerUtil.info('Level: $level');
        
        if (_mainImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الرجاء اختيار الصورة الرئيسية')),
          );
          return;
        }

        await _exerciseCubit.addExercise(
          categoryId: widget.categoryId,
          title: title,
          description: description,
          mainImage: _mainImage!,
          images: _images,
          level: level,
        );
      }

      LoggerUtil.info('Exercise saved successfully');
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      LoggerUtil.error('Error saving exercise: $e');
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
      value: _exerciseCubit,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: TColor.secondary,
          title: Text(
            _isEditing ? 'تعديل التمرين' : 'إضافة تمرين جديد',
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ExerciseForm(
              exercise: widget.exercise,
              categoryTitle: widget.categoryTitle,
              onSave: _saveExercise,
              onMainImagePicked: (image) {
                setState(() {
                  _mainImage = image;
                });
              },
              onAdditionalImagesPicked: (images) {
                setState(() {
                  _images = images;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
} 