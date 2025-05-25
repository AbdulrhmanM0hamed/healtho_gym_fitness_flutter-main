import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_day_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_cubit.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_state.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/widgets/dashboard_workout_day_form.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/screens/dashboard_workout_day_details_screen.dart';
import 'package:healtho_gym/core/widgets/loading_indicator.dart';
import 'package:healtho_gym/core/widgets/error_view.dart';

/// شاشة تفاصيل أسبوع التمرين في لوحة التحكم
class DashboardWorkoutWeekDetailsScreen extends StatefulWidget {
  final int weekId;
  final int weekNumber;
  final int planId;

  const DashboardWorkoutWeekDetailsScreen({
    Key? key,
    required this.weekId,
    required this.weekNumber,
    required this.planId,
  }) : super(key: key);

  @override
  State<DashboardWorkoutWeekDetailsScreen> createState() => _DashboardWorkoutWeekDetailsScreenState();
}

class _DashboardWorkoutWeekDetailsScreenState extends State<DashboardWorkoutWeekDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadDays();
  }

  void _loadDays() {
    context.read<DashboardWorkoutPlanCubit>().getDaysForWeek(widget.weekId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأسبوع ${widget.weekNumber}'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadDays();
        },
        child: BlocConsumer<DashboardWorkoutPlanCubit, DashboardWorkoutPlanState>(
          listener: (context, state) {
            if (state is DashboardWorkoutPlanActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              
              // Reload data after successful action
              if (state.entityType == 'day') {
                _loadDays();
              }
            }
          },
          builder: (context, state) {
            // First check if we have days data to display
            if (state is DashboardWorkoutDaysLoaded && state.weekId == widget.weekId) {
              return _buildDaysList(context, state.days);
            }
            
            // Check for loading state
            if (state is DashboardWorkoutPlanLoading) {
              return const Center(child: LoadingIndicator());
            } 
            
            // Check for error state
            else if (state is DashboardWorkoutPlanError) {
              return ErrorView(
                message: state.message,
                onRetry: _loadDays,
              );
            } 
            
            // Check for success action state
            else if (state is DashboardWorkoutPlanActionSuccess) {
              // Automatically reload data after a short delay
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  _loadDays();
                }
              });
              
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadDays,
                      child: const Text('تحديث البيانات'),
                    ),
                  ],
                ),
              );
            } 
            
            // Fallback - show loading instead of "choose a week"
            else {
              // Try to load days again
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  _loadDays();
                }
              });
              
              return const Center(child: LoadingIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDayDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDaysList(BuildContext context, List<DashboardWorkoutDayModel> days) {
    if (days.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'لا توجد أيام في هذا الأسبوع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'اضغط على زر الإضافة لإنشاء يوم جديد',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _showAddDayDialog(context),
              child: const Text('إضافة يوم'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              _getDayName(day.dayNumber),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(day.dayName),
                const SizedBox(height: 8),
                Text(
                  day.isRestDay ? 'يوم راحة' : 'يوم تمرين',
                  style: TextStyle(
                    color: day.isRestDay ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditDayDialog(context, day),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteDay(context, day),
                ),
              ],
            ),
            onTap: () {
              if (!day.isRestDay) {
                // Store the cubit instance before navigation
                final cubit = context.read<DashboardWorkoutPlanCubit>();
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: cubit,
                      child: DashboardWorkoutDayDetailsScreen(
                        dayId: day.id!,
                        dayNumber: day.dayNumber,
                        weekId: widget.weekId,
                      ),
                    ),
                  ),
                ).then((_) => _loadDays());
              }
            },
          ),
        );
      },
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

  void _showAddDayDialog(BuildContext context) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();
    
    final newDay = DashboardWorkoutDayModel(
      weekId: widget.weekId,
      dayName: 'اليوم الأول',
      dayNumber: 1,
      isRestDay: false,
    );

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: DashboardWorkoutDayForm(
          day: newDay,
          onSubmit: (day) {
            // استخدم مرجع الـ cubit المحفوظ بدلاً من محاولة قراءته من سياق الحوار
            cubit.addDayToWeek(day);
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _showEditDayDialog(BuildContext context, DashboardWorkoutDayModel day) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: DashboardWorkoutDayForm(
          day: day,
          onSubmit: (updatedDay) {
            // استخدم مرجع الـ cubit المحفوظ بدلاً من محاولة قراءته من سياق الحوار
            cubit.updateDay(updatedDay);
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _confirmDeleteDay(BuildContext context, DashboardWorkoutDayModel day) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف ${_getDayName(day.dayNumber)}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              context.read<DashboardWorkoutPlanCubit>().deleteDay(day.id!, widget.weekId);
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
