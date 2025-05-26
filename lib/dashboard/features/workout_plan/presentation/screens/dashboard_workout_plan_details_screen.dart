import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_plan_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_week_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_cubit.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_state.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/widgets/dashboard_workout_week_form.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/screens/dashboard_workout_week_details_screen.dart';
import 'package:healtho_gym/core/widgets/loading_indicator.dart';
import 'package:healtho_gym/core/widgets/error_view.dart';

/// شاشة تفاصيل خطة التمرين في لوحة التحكم
class DashboardWorkoutPlanDetailsScreen extends StatefulWidget {
  final int planId;

  const DashboardWorkoutPlanDetailsScreen({
    Key? key,
    required this.planId,
  }) : super(key: key);

  @override
  State<DashboardWorkoutPlanDetailsScreen> createState() => _DashboardWorkoutPlanDetailsScreenState();
}

class _DashboardWorkoutPlanDetailsScreenState extends State<DashboardWorkoutPlanDetailsScreen> {
  DashboardWorkoutPlanModel? plan;
  List<DashboardWorkoutWeekModel> _weeks = [];
  bool _isLoading = true;
  bool _isInitialLoadDone = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Delay initial load slightly to avoid build issues
    Future.microtask(_loadPlanDetails);
  }

  Future<void> _loadPlanDetails() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Load plan details first
      await context.read<DashboardWorkoutPlanCubit>().getWorkoutPlanById(widget.planId);
      // Then load weeks for the plan (only once)
      if (!_isInitialLoadDone) {
        await context.read<DashboardWorkoutPlanCubit>().getWeeksForPlan(widget.planId);
        _isInitialLoadDone = true;
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل بيانات الخطة: $e';
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
        title: Text(plan?.title ?? 'تفاصيل الخطة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPlanDetails,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPlanDetails,
        child: BlocListener<DashboardWorkoutPlanCubit, DashboardWorkoutPlanState>(
          listener: (context, state) {
            // Handle state changes
            if (state is DashboardWorkoutPlanActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              
              // Reload data after successful action
              if (state.entityType == 'week') {
                _loadPlanDetails();
              }
            }
            
            // Update local state based on bloc state
            if (state is DashboardWorkoutWeeksLoaded && state.planId == widget.planId) {
              setState(() {
                _weeks = state.weeks;
                _isLoading = false;
                _errorMessage = null;
              });
            } else if (state is DashboardWorkoutPlanLoaded && state.plan.id == widget.planId) {
              setState(() {
                plan = state.plan;
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
                onRetry: _loadPlanDetails,
              );
            }
            
            // Show weeks list or empty state
            return _weeks.isEmpty ? _buildEmptyWeeksList(context) : _buildWeeksList(context, _weeks);
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWeekDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWeeksList(BuildContext context, List<DashboardWorkoutWeekModel> weeks) {
    if (weeks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'لا توجد أسابيع في هذه الخطة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'اضغط على زر الإضافة لإنشاء أسبوع جديد',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddWeekDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('إضافة أسبوع'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: weeks.length,
      itemBuilder: (context, index) {
        final week = weeks[index];
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
                      child: DashboardWorkoutWeekDetailsScreen(
                        weekId: week.id!,
                        weekNumber: week.weekNumber,
                        planId: widget.planId,
                      ),
                    ),
                  ),
                ).then((_) => _loadPlanDetails());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with week number and actions
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
                        const Icon(Icons.calendar_month, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'الأسبوع ${week.weekNumber}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'تعديل',
                          onPressed: () => _showEditWeekDialog(context, week),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'حذف',
                          onPressed: () => _confirmDeleteWeek(context, week),
                        ),
                      ],
                    ),
                  ),
                  // Week description
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (week.description.isNotEmpty) ...[  
                          const Text(
                            'الوصف:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            week.description,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ] else ...[  
                          const Text(
                            'لا يوجد وصف',
                            style: TextStyle(color: Colors.black45, fontStyle: FontStyle.italic),
                          ),
                        ],
                        const SizedBox(height: 8),
                        // View details button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              // Store the cubit instance before navigation
                              final cubit = context.read<DashboardWorkoutPlanCubit>();
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: cubit,
                                    child: DashboardWorkoutWeekDetailsScreen(
                                      weekId: week.id!,
                                      weekNumber: week.weekNumber,
                                      planId: widget.planId,
                                    ),
                                  ),
                                ),
                              ).then((_) => _loadPlanDetails());
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('عرض التفاصيل'),
                          ),
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

  void _showAddWeekDialog(BuildContext context) {
    final newWeek = DashboardWorkoutWeekModel(
      planId: widget.planId,
      weekNumber: 1,
      title: 'الأسبوع 1',
      description: '',
    );

    // Capture the cubit instance before showing the dialog
    final cubit = context.read<DashboardWorkoutPlanCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: DashboardWorkoutWeekForm(
          week: newWeek,
          onSubmit: (week) {
            // Use the captured cubit instance instead of trying to read from the dialog context
            cubit.addWeekToPlan(week);
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _showEditWeekDialog(BuildContext context, DashboardWorkoutWeekModel week) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: DashboardWorkoutWeekForm(
          week: week,
          onSubmit: (updatedWeek) {
            context.read<DashboardWorkoutPlanCubit>().updateWeek(updatedWeek);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _confirmDeleteWeek(BuildContext context, DashboardWorkoutWeekModel week) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الأسبوع ${week.weekNumber}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteWeek(week.id!, widget.planId);
              Navigator.pop(dialogContext);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  /// بناء واجهة لقائمة أسابيع فارغة
  Widget _buildEmptyWeeksList(BuildContext context) {
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
            child: const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد أسابيع في هذه الخطة',
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
              'قم بإضافة أسبوع جديد لبدء تنظيم خطة التمرين الخاصة بك',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddWeekDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('إضافة أسبوع جديد'),
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
