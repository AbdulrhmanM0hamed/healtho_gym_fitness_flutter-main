import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_day_exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/exercise_model.dart';

/// نموذج إضافة/تعديل تمرين ليوم محدد
class DashboardDayExerciseForm extends StatefulWidget {
  final DashboardDayExerciseModel exercise;
  final Function(DashboardDayExerciseModel) onSubmit;

  const DashboardDayExerciseForm({
    Key? key,
    required this.exercise,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<DashboardDayExerciseForm> createState() => _DashboardDayExerciseFormState();
}

class _DashboardDayExerciseFormState extends State<DashboardDayExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _notesController;
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late TextEditingController _restTimeController;
  
  ExerciseModel? _selectedExercise;
  List<ExerciseModel> _exercises = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.exercise.notes);
    _setsController = TextEditingController(text: widget.exercise.sets.toString());
    _repsController = TextEditingController(text: widget.exercise.reps.toString());
    _weightController = TextEditingController(text: widget.exercise.weight != null ? widget.exercise.weight.toString() : '0');
    _restTimeController = TextEditingController(text: widget.exercise.restTime.toString());
    
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      // محاكاة للحصول على قائمة التمارين
      // في التطبيق الفعلي يجب استخدام مستودع التمارين
      await Future.delayed(const Duration(milliseconds: 500));
      final mockExercises = [
        ExerciseModel(id: 1, title: 'تمرين ضغط الصدر', mainImageUrl: ''),
        ExerciseModel(id: 2, title: 'تمرين القرفصاء', mainImageUrl: ''),
        ExerciseModel(id: 3, title: 'تمرين السحب', mainImageUrl: ''),
        ExerciseModel(id: 4, title: 'تمرين الضغط الأمامي', mainImageUrl: ''),
      ];
      
      setState(() {
        _exercises = mockExercises;
        _isLoading = false;
        
        // تحديد التمرين المختار إذا كان موجوداً
        if (_exercises.isNotEmpty) {
          if (widget.exercise.exerciseId != 0) {
            _selectedExercise = _exercises.firstWhere(
              (e) => e.id == widget.exercise.exerciseId,
              orElse: () => _exercises.first,
            );
          } else {
            _selectedExercise = _exercises.first;
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل في تحميل قائمة التمارين: $e';
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _restTimeController.dispose();
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
                widget.exercise.id == null ? 'إضافة تمرين جديد' : 'تعديل التمرين',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Center(
                  child: Column(
                    children: [
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadExercises,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              else ...[
                const Text('اختر التمرين:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<ExerciseModel>(
                  value: _selectedExercise,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'اختر التمرين',
                  ),
                  items: _exercises.map((exercise) => DropdownMenuItem<ExerciseModel>(
                    value: exercise,
                    child: Text(exercise.title ?? 'تمرين بدون اسم'),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedExercise = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'يرجى اختيار تمرين';
                    }
                    return null;
                  },
                ),
              ],
              
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: const InputDecoration(
                        labelText: 'المجموعات',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مطلوب';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: const InputDecoration(
                        labelText: 'التكرارات',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مطلوب';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'الوزن (كجم)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _restTimeController,
                      decoration: const InputDecoration(
                        labelText: 'وقت الراحة (ثانية)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                    onPressed: _isLoading || _errorMessage != null ? null : _submitForm,
                    child: Text(widget.exercise.id == null ? 'إضافة' : 'تحديث'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedExercise != null) {
      final exercise = DashboardDayExerciseModel(
        id: widget.exercise.id,
        dayId: widget.exercise.dayId,
        exerciseId: _selectedExercise!.id,
        sets: int.tryParse(_setsController.text) ?? 3,
        reps: int.tryParse(_repsController.text) ?? 12,
        weight: double.tryParse(_weightController.text),
        restTime: int.tryParse(_restTimeController.text) ?? 60,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        sortOrder: widget.exercise.sortOrder,
        exerciseName: _selectedExercise!.title,
        exerciseImage: _selectedExercise!.mainImageUrl ?? '',
        createdAt: widget.exercise.createdAt,
        updatedAt: DateTime.now(),
        exerciseDetails: _selectedExercise,
      );
      
      widget.onSubmit(exercise);
    }
  }
}
