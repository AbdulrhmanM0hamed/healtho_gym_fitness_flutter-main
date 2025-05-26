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
  bool _isInitialLoadDone = false;
  List<DashboardWorkoutDayModel> _days = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    // Delay initial load slightly to avoid build issues
    Future.microtask(_loadDays);
  }

  Future<void> _loadDays() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final cubit = context.read<DashboardWorkoutPlanCubit>();
      await cubit.getDaysForWeek(widget.weekId);
      _isInitialLoadDone = true;
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل الأيام: $e';
        });
      }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('الأسبوع ${widget.weekNumber}'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadDays();
        },
        child: BlocListener<DashboardWorkoutPlanCubit, DashboardWorkoutPlanState>(
          listener: (context, state) {
            // Handle state changes
            if (state is DashboardWorkoutPlanActionSuccess) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              
              // Reload data after successful action
              if (state.entityType == 'day') {
                _loadDays();
              }
            }
            
            // Update local state based on bloc state
            if (state is DashboardWorkoutDaysLoaded && state.weekId == widget.weekId) {
              setState(() {
                _days = state.days;
                _isLoading = false;
                _errorMessage = null;
                _isInitialLoadDone = true;
              });
            } else if (state is DashboardWorkoutPlanError) {
              setState(() {
                _errorMessage = state.message;
                _isLoading = false;
              });
            }
          },
          child: Builder(builder: (context) {
            // Show loading state
            if (_isLoading && !_isInitialLoadDone) {
              return const Center(child: LoadingIndicator());
            }
            
            // Show error state
            if (_errorMessage != null) {
              return ErrorView(
                message: _errorMessage!,
                onRetry: _loadDays,
              );
            }
            
            // Show days list or empty state
            return _days.isEmpty ? _buildEmptyDaysList(context) : _buildDaysList(context, _days);
          }),
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
      return _buildEmptyDaysList(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
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
                        dayTitle: day.dayName,
                        weekId: widget.weekId,
                      ),
                    ),
                  ),
                ).then((_) => _loadDays());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with day number and actions
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.dayNumber}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            day.dayName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'تعديل',
                          onPressed: () => _showEditDayDialog(context, day),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'حذف',
                          onPressed: () => _confirmDeleteDay(context, day),
                        ),
                      ],
                    ),
                  ),
                  // Day description and details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Day type indicator
                        Text(
                          day.isRestDay ? 'يوم راحة' : 'يوم تمرين',
                          style: TextStyle(
                            color: day.isRestDay ? Colors.orange : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Exercise count
                        if (day.totalExercises > 0) ...[  
                          Text(
                            'عدد التمارين: ${day.totalExercises}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ] else ...[  
                          const Text(
                            'لا يوجد تمارين مضافة',
                            style: TextStyle(color: Colors.black45, fontStyle: FontStyle.italic),
                          ),
                        ],
                        const SizedBox(height: 12),
                        // View exercises button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('عرض تمارين اليوم',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
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
                              },
                              icon: const Icon(Icons.fitness_center, size: 18),
                              label: const Text('عرض'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ],
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
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف ${_getDayName(day.dayNumber)}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteDay(day.id!, widget.weekId);
              Navigator.pop(dialogContext);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  /// بناء واجهة لقائمة أيام فارغة
  Widget _buildEmptyDaysList(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد أيام في هذا الأسبوع',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'قم بإضافة أيام التمرين لهذا الأسبوع لتنظيم جدولك التدريبي',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddDayDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('إضافة يوم جديد'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
