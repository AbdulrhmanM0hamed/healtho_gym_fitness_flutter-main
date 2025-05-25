import 'package:flutter/material.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_week_model.dart';

/// نموذج إضافة/تعديل أسبوع تمرين
class DashboardWorkoutWeekForm extends StatefulWidget {
  final DashboardWorkoutWeekModel week;
  final Function(DashboardWorkoutWeekModel) onSubmit;

  const DashboardWorkoutWeekForm({
    Key? key,
    required this.week,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<DashboardWorkoutWeekForm> createState() => _DashboardWorkoutWeekFormState();
}

class _DashboardWorkoutWeekFormState extends State<DashboardWorkoutWeekForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _titleController;
  late int _weekNumber;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.week.title);
    _descriptionController = TextEditingController(text: widget.week.description);
    _weekNumber = widget.week.weekNumber;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
                widget.week.id == null ? 'إضافة أسبوع جديد' : 'تعديل الأسبوع',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('رقم الأسبوع:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _weekNumber,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(12, (index) => index + 1)
                          .map((number) => DropdownMenuItem<int>(
                                value: number,
                                child: Text('الأسبوع $number'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _weekNumber = value ?? 1;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'يرجى اختيار رقم الأسبوع';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان الأسبوع *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان الأسبوع';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف الأسبوع',
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
                    onPressed: _submitForm,
                    child: Text(widget.week.id == null ? 'إضافة' : 'تحديث'),
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
    if (_formKey.currentState!.validate()) {
      final week = DashboardWorkoutWeekModel(
        id: widget.week.id,
        planId: widget.week.planId,
        weekNumber: _weekNumber,
        title: _titleController.text,
        description: _descriptionController.text.isEmpty ? '' : _descriptionController.text,
        createdAt: widget.week.createdAt,
        updatedAt: DateTime.now(),
      );
      
      widget.onSubmit(week);
    }
  }
}
