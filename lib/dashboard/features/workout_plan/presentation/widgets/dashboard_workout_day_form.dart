import 'package:flutter/material.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_day_model.dart';

/// نموذج إضافة/تعديل يوم تمرين
class DashboardWorkoutDayForm extends StatefulWidget {
  final DashboardWorkoutDayModel day;
  final Function(DashboardWorkoutDayModel) onSubmit;

  const DashboardWorkoutDayForm({
    Key? key,
    required this.day,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<DashboardWorkoutDayForm> createState() => _DashboardWorkoutDayFormState();
}

class _DashboardWorkoutDayFormState extends State<DashboardWorkoutDayForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dayNameController;
  late int _dayNumber;
  late bool _isRestDay;

  @override
  void initState() {
    super.initState();
    _dayNameController = TextEditingController(text: widget.day.dayName);
    _dayNumber = widget.day.dayNumber;
    _isRestDay = widget.day.isRestDay;
  }

  @override
  void dispose() {
    _dayNameController.dispose();
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
                widget.day.id == null ? 'إضافة يوم جديد' : 'تعديل اليوم',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('رقم اليوم:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _dayNumber,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(7, (index) => index + 1)
                          .map((number) => DropdownMenuItem<int>(
                                value: number,
                                child: Text(_getDayName(number)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _dayNumber = value ?? 1;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'يرجى اختيار رقم اليوم';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dayNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم اليوم *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم اليوم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: _isRestDay,
                    onChanged: (value) {
                      setState(() {
                        _isRestDay = value ?? false;
                      });
                    },
                  ),
                  const Text('يوم راحة'),
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
                    child: Text(widget.day.id == null ? 'إضافة' : 'تحديث'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDayName(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return 'اليوم الأول';
      case 2:
        return 'اليوم الثاني';
      case 3:
        return 'اليوم الثالث';
      case 4:
        return 'اليوم الرابع';
      case 5:
        return 'اليوم الخامس';
      case 6:
        return 'اليوم السادس';
      case 7:
        return 'اليوم السابع';
      default:
        return 'اليوم $dayNumber';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final day = DashboardWorkoutDayModel(
        id: widget.day.id,
        weekId: widget.day.weekId,
        dayName: _dayNameController.text,
        dayNumber: _dayNumber,
        isRestDay: _isRestDay,
        totalExercises: widget.day.totalExercises,
        majorExercises: widget.day.majorExercises,
        minorExercises: widget.day.minorExercises,
        createdAt: widget.day.createdAt,
        updatedAt: DateTime.now(),
      );
      
      widget.onSubmit(day);
    }
  }
}
