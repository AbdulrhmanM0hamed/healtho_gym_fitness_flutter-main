import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:healtho_gym/core/theme/app_colors.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_plan_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_cubit.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_state.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/widgets/dashboard_workout_plan_form.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/screens/dashboard_workout_plan_details_screen.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/components/workout_plan_card.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/theme/workout_plan_theme.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/utils/workout_plan_utils.dart';
import 'package:healtho_gym/core/widgets/loading_indicator.dart';
import 'package:healtho_gym/core/widgets/error_view.dart';

/// شاشة عرض خطط التمرين في لوحة التحكم
class DashboardWorkoutPlansScreen extends StatefulWidget {
  const DashboardWorkoutPlansScreen({Key? key}) : super(key: key);

  @override
  State<DashboardWorkoutPlansScreen> createState() =>
      _DashboardWorkoutPlansScreenState();
}

class _DashboardWorkoutPlansScreenState
    extends State<DashboardWorkoutPlansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    // إنشاء متحكم التبويبات
    _tabController = TabController(length: 3, vsync: this);
    // تحميل خطط التمرين عند بدء الشاشة
    _loadWorkoutPlans();

    // إضافة مستمع للبحث
    _searchController.addListener(_onSearchChanged);
  }
  
  // دالة مستقلة لتحميل خطط التمرين
  void _loadWorkoutPlans() {
    if (mounted) {
      context.read<DashboardWorkoutPlanCubit>().getAllWorkoutPlans();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خطط التمرين',
            style: TextStyle(color: AppColors.secondary)),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'المميزة'),
            Tab(text: 'الأحدث'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
            onPressed: () =>
                context.read<DashboardWorkoutPlanCubit>().getAllWorkoutPlans(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardWorkoutPlanCubit>().getAllWorkoutPlans();
              },
              child: BlocConsumer<DashboardWorkoutPlanCubit,
                  DashboardWorkoutPlanState>(
                listener: (context, state) {
                  if (state is DashboardWorkoutPlanActionSuccess) {
                    WorkoutPlanUtils.showSuccessSnackBar(
                        context, state.message);

                    // Reload plans after any action
                    if (state.entityType == 'plan') {
                      context
                          .read<DashboardWorkoutPlanCubit>()
                          .getAllWorkoutPlans();
                    }
                  } else if (state is DashboardWorkoutPlanError) {
                    WorkoutPlanUtils.showErrorSnackBar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is DashboardWorkoutPlanLoading) {
                    return const Center(child: LoadingIndicator());
                  } else if (state is DashboardWorkoutPlanError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () => context
                          .read<DashboardWorkoutPlanCubit>()
                          .getAllWorkoutPlans(),
                    );
                  } else if (state is DashboardWorkoutPlansLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        // الكل
                        _buildWorkoutPlansList(
                            context, _filterPlans(state.plans)),
                        // المميزة
                        _buildWorkoutPlansList(
                            context,
                            _filterPlans(state.plans
                                .where((plan) => plan.isFeatured)
                                .toList())),
                        // الأحدث
                        _buildWorkoutPlansList(
                            context,
                            _filterPlans(state.plans.toList()
                              ..sort((a, b) => (b.updatedAt ?? DateTime.now())
                                  .compareTo(a.updatedAt ?? DateTime.now())))),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkoutPlanDialog(context),
        backgroundColor: WorkoutPlanTheme.primaryColor,
        child: const Icon(Icons.add),
        tooltip: 'إضافة خطة تمرين جديدة',
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: WorkoutPlanTheme.primaryColor.withOpacity(0.05),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن خطة تمرين...',
          prefixIcon:
              const Icon(Icons.search, color: WorkoutPlanTheme.primaryColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  List<DashboardWorkoutPlanModel> _filterPlans(
      List<DashboardWorkoutPlanModel> plans) {
    if (_searchQuery.isEmpty) return plans;

    return plans.where((plan) {
      return plan.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          plan.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          plan.goal.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          plan.level.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildWorkoutPlansList(
      BuildContext context, List<DashboardWorkoutPlanModel> plans) {
    if (plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isNotEmpty
                  ? 'لا توجد نتائج مطابقة لـ "$_searchQuery"'
                  : 'لا توجد خطط تمرين',
              style: WorkoutPlanTheme.headingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'حاول البحث بكلمات مختلفة'
                  : 'اضغط على زر الإضافة لإنشاء خطة تمرين جديدة',
              style: WorkoutPlanTheme.captionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_searchQuery.isEmpty)
              ElevatedButton.icon(
                onPressed: () => _showAddWorkoutPlanDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('إضافة خطة تمرين'),
                style: WorkoutPlanTheme.primaryButtonStyle,
              ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: WorkoutPlanCard(
                  plan: plan,
                  onTap: () {
                    // Store the cubit instance before navigation
                    final cubit = context.read<DashboardWorkoutPlanCubit>();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: DashboardWorkoutPlanDetailsScreen(
                              planId: plan.id!),
                        ),
                      ),
                    ).then((_) {
                      // إعادة تحميل البيانات عند العودة من شاشة التفاصيل
                      if (mounted) {
                        cubit.getAllWorkoutPlans();
                      }
                    });
                  },
                  onEdit: () => _showEditWorkoutPlanDialog(context, plan),
                  onDelete: () => _confirmDeleteWorkoutPlan(context, plan),
                  onToggleFeatured: () {
                    final updatedPlan =
                        plan.copyWith(isFeatured: !plan.isFeatured);
                    context
                        .read<DashboardWorkoutPlanCubit>()
                        .updateWorkoutPlan(updatedPlan);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddWorkoutPlanDialog(BuildContext context) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: DashboardWorkoutPlanForm(
            onSubmit: (plan) {
              // استخدم مرجع الـ cubit بدلاً من محاولة الوصول إليه من سياق الحوار
              cubit.addWorkoutPlan(plan);
              Navigator.pop(dialogContext);
            },
          ),
        ),
      ),
    );
  }

  void _showEditWorkoutPlanDialog(
      BuildContext context, DashboardWorkoutPlanModel plan) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: DashboardWorkoutPlanForm(
            plan: plan,
            onSubmit: (updatedPlan) {
              // استخدم مرجع الـ cubit بدلاً من محاولة الوصول إليه من سياق الحوار
              cubit.updateWorkoutPlan(updatedPlan);
              Navigator.pop(dialogContext);
            },
          ),
        ),
      ),
    );
  }

  void _confirmDeleteWorkoutPlan(
      BuildContext context, DashboardWorkoutPlanModel plan) {
    // احتفظ بمرجع للـ cubit من السياق الأصلي
    final cubit = context.read<DashboardWorkoutPlanCubit>();

    WorkoutPlanUtils.showConfirmationDialog(
      context: context,
      title: 'تأكيد الحذف',
      content: 'هل أنت متأكد من حذف خطة التمرين "${plan.title}"؟',
      confirmText: 'حذف',
      cancelText: 'إلغاء',
      confirmColor: WorkoutPlanTheme.errorColor,
    ).then((confirmed) {
      if (confirmed) {
        cubit.deleteWorkoutPlan(plan.id!);
      }
    });
  }
}
