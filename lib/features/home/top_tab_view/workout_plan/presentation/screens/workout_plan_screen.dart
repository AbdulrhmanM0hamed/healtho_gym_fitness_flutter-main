import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/repositories/filters_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/screens/workout_detail_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/viewmodels/workout_plan_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/plan/plan_card.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/plan/plan_filters.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  late WorkoutPlanCubit _workoutPlanCubit;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  
  // Filter variables
  String selectedCategory = 'All';
  String selectedLevel = 'All';
  String selectedDuration = 'All';
  bool isFilterApplied = false;

  // Filter data
  List<String> categories = ['All'];
  Map<String, int> categoryIds = {'All': 0};
  List<String> levels = ['All', 'مبتدئ', 'متقدم', 'محترف'];
  List<String> durations = ['All', '4 Weeks', '8 Weeks', '12 Weeks'];
  
  @override
  void initState() {
    super.initState();
    _workoutPlanCubit = sl<WorkoutPlanCubit>();
    _workoutPlanCubit.getWorkoutPlans();
    _loadFilterData();
  }
  
  Future<void> _loadFilterData() async {
    try {
      // Load categories
      final categoriesData = await sl<FiltersRepository>().getCategories();
      final categoryList = ['All'];
      final categoryIdMap = {'All': 0};
      
      for (var category in categoriesData) {
        categoryList.add(category.name);
        categoryIdMap[category.name] = category.id;
      }
      
      // Load levels
      final levelsData = await sl<FiltersRepository>().getLevels();
      final levelsList = ['All', ...levelsData];
      
      // Load durations
      final durationsData = await sl<FiltersRepository>().getDurations();
      final durationsList = ['All', ...durationsData];
      
      setState(() {
        categories = categoryList;
        categoryIds = categoryIdMap;
        levels = levelsList;
        durations = durationsList;
      });
      
      // Debug print to verify data
      print('Categories loaded: $categoryList');
      print('Category IDs: $categoryIdMap');
      print('Levels loaded: $levelsList');
      print('Durations loaded: $durationsList');
    } catch (e) {
      // Use default values in case of error
      print('Error loading filter data: $e');
    }
  }
  
  Future<void> _refreshPlans() async {
    _workoutPlanCubit.getWorkoutPlans();
  }
  
  void _applyFilters() {
    int? categoryId;
    if (selectedCategory != 'All') {
      categoryId = categoryIds[selectedCategory];
      print('Filtering by category: $selectedCategory (ID: $categoryId)');
    }
    
    String? levelFilter;
    if (selectedLevel != 'All') {
      levelFilter = selectedLevel;
      print('Filtering by level: $levelFilter');
    }
    
    String? durationFilter = selectedDuration == 'All' ? null : selectedDuration;
    if (durationFilter != null) {
      print('Filtering by duration: $durationFilter');
    }
    
    setState(() {
      isFilterApplied = true;
    });
    
    _workoutPlanCubit.filterPlans(
      categoryId: categoryId,
      level: levelFilter,
      duration: durationFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _workoutPlanCubit,
      child: Scaffold(
        body: Column(
          children: [
            // Filters section
            PlanFilters(
              selectedCategory: selectedCategory,
              selectedLevel: selectedLevel,
              selectedDuration: selectedDuration,
              categories: categories,
              levels: levels,
              durations: durations,
              onCategoryChanged: (String? newValue) {
                if (newValue != null) {
                  print('Category changed to: $newValue');
                  setState(() {
                    selectedCategory = newValue;
                  });
                  _applyFilters();
                }
              },
              onLevelChanged: (String? newValue) {
                if (newValue != null) {
                  print('Level changed to: $newValue');
                  setState(() {
                    selectedLevel = newValue;
                  });
                  _applyFilters();
                }
              },
              onDurationChanged: (String? newValue) {
                if (newValue != null) {
                  print('Duration changed to: $newValue');
                  setState(() {
                    selectedDuration = newValue;
                  });
                  _applyFilters();
                }
              },
            ),
            
            // Plans list
            Expanded(
              child: BlocBuilder<WorkoutPlanCubit, WorkoutPlanState>(
                builder: (context, state) {
                  if (state is WorkoutPlanLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WorkoutPlanError) {
                    return Center(child: Text(state.message));
                  } else if (state is WorkoutPlansListLoaded) {
                    final plans = state.plans;
                    
                    if (plans.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('لا توجد خطط تمارين مطابقة للفلتر'),
                            const SizedBox(height: 20),
                            RoundButton(
                              title: "إعادة ضبط الفلاتر",
                              onPressed: () {
                                setState(() {
                                  selectedCategory = 'All';
                                  selectedLevel = 'All';
                                  selectedDuration = 'All';
                                  isFilterApplied = false;
                                });
                                _refreshPlans();
                                print('Filters reset to default');
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refreshPlans,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        itemCount: plans.length + (state.hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == plans.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: RoundButton(
                                  title: "تحميل المزيد",
                                  onPressed: () {
                                    context.read<WorkoutPlanCubit>().loadMorePlans();
                                  },
                                ),
                              ),
                            );
                          }
                          
                          final plan = plans[index];
                          return PlanCard(
                            plan: plan,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutDetailScreen(
                                    planId: plan.id,
                                  ),
                                ),
                              );
                            },
                            onFavoriteClick: () {
                              try {
                                context.read<WorkoutPlanCubit>().togglePlanFavorite(plan.id);
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      plan.isFavorite
                                          ? 'تمت إزالة الخطة من المفضلة'
                                          : 'تمت إضافة الخطة للمفضلة',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              } catch (e) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('حدث خطأ أثناء تحديث المفضلة'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  }
                  
                  return const Center(child: Text('جاري تحميل خطط التمرين...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 