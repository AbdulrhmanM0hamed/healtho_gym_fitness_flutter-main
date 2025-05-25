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

  @override
  void initState() {
    super.initState();
    _loadPlanDetails();
  }

  void _loadPlanDetails() {
    // Load plan details and weeks for the plan
    context.read<DashboardWorkoutPlanCubit>().getWorkoutPlanById(widget.planId);
    context.read<DashboardWorkoutPlanCubit>().getWeeksForPlan(widget.planId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<DashboardWorkoutPlanCubit, DashboardWorkoutPlanState>(
          builder: (context, state) {
            if (state is DashboardWorkoutPlanLoaded) {
              plan = state.plan;
              return Text(state.plan.title);
            }
            return const Text('تفاصيل الخطة');
          },
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadPlanDetails();
        },
        child: BlocConsumer<DashboardWorkoutPlanCubit, DashboardWorkoutPlanState>(
          listener: (context, state) {
            if (state is DashboardWorkoutPlanActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              
              // Reload data after successful action
              if (state.entityType == 'week') {
                _loadPlanDetails();
              }
            }
          },
          builder: (context, state) {
            // First check if we have weeks data to display
            if (state is DashboardWorkoutWeeksLoaded) {
              return _buildWeeksList(context, state.weeks);
            }
            
            // Check for loading state
            if (state is DashboardWorkoutPlanLoading) {
              return const Center(child: LoadingIndicator());
            } 
            
            // Check for error state
            else if (state is DashboardWorkoutPlanError) {
              return ErrorView(
                message: state.message,
                onRetry: _loadPlanDetails,
              );
            } 
            
            // Check for success action state
            else if (state is DashboardWorkoutPlanActionSuccess) {
              // Automatically reload data after a short delay
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  _loadPlanDetails();
                }
              });
              
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadPlanDetails,
                      child: const Text('تحديث البيانات'),
                    ),
                  ],
                ),
              );
            } 
            
            // If we have a plan loaded but no weeks yet, show loading
            else if (plan != null) {
              // Try to load weeks again if we have a plan but no weeks
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  context.read<DashboardWorkoutPlanCubit>().getWeeksForPlan(widget.planId);
                }
              });
              
              return const Center(child: LoadingIndicator());
            }
            
            // Fallback - show loading instead of "choose a plan"
            else {
              return const Center(child: LoadingIndicator());
            }
          },
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
            ElevatedButton(
              onPressed: () => _showAddWeekDialog(context),
              child: const Text('إضافة أسبوع'),
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
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'الأسبوع ${week.weekNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(week.description),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditWeekDialog(context, week),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteWeek(context, week),
                ),
              ],
            ),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الأسبوع ${week.weekNumber}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              context.read<DashboardWorkoutPlanCubit>().deleteWeek(week.id!, widget.planId);
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
