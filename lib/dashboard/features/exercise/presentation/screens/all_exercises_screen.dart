import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/models/exercise_model.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/screens/add_edit_exercise_screen.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_state.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/widgets/exercise_card.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/models/exercise_category_model.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_state.dart';

class AllExercisesScreen extends StatefulWidget {
  const AllExercisesScreen({super.key});

  @override
  State<AllExercisesScreen> createState() => _AllExercisesScreenState();
}

class _AllExercisesScreenState extends State<AllExercisesScreen> {
  late final ExerciseCubit _exerciseCubit;
  late final ExerciseCategoryCubit _categoryCubit;
  int _selectedCategoryId = 0;
  int _selectedLevel = 1;

  @override
  void initState() {
    super.initState();
    _exerciseCubit = sl<ExerciseCubit>();
    _categoryCubit = sl<ExerciseCategoryCubit>();
    _categoryCubit.loadCategories();
    _loadExercises();
  }

  @override
  void dispose() {
    _exerciseCubit.close();
    _categoryCubit.close();
    super.dispose();
  }

  void _loadExercises() {
    _exerciseCubit.loadExercises(_selectedCategoryId, _selectedLevel);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _exerciseCubit),
        BlocProvider.value(value: _categoryCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.secondary,
          title: const Text(
            'جميع التمارين',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            // Category Filter
            BlocBuilder<ExerciseCategoryCubit, ExerciseCategoryState>(
              builder: (context, state) {
                if (state is ExerciseCategoryLoaded) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedCategoryId,
                        dropdownColor: TColor.secondary,
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: [
                          const DropdownMenuItem(
                            value: 0,
                            child: Text('كل الفئات'),
                          ),
                          ...state.categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Text(category.titleAr),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                            _loadExercises();
                          }
                        },
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            // Level Filter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedLevel,
                  dropdownColor: TColor.secondary,
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: [1, 2, 3].map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text('المستوى $level'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLevel = value;
                      });
                      _loadExercises();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ExerciseCubit, ExerciseState>(
          builder: (context, state) {
            if (state is ExerciseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExerciseError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'خطأ: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadExercises,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is ExerciseLoaded) {
              if (state.exercises.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد تمارين في المستوى $_selectedLevel',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'أضف تمرين جديد لبدء القائمة',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = state.exercises[index];
                  return _buildExerciseCard(context, exercise);
                },
              );
            }

            return const Center(
              child: Text('حدث خطأ غير متوقع'),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: TColor.primary,
          onPressed: () {
            if (_selectedCategoryId == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الرجاء اختيار فئة أولاً')),
              );
              return;
            }

            final state = _categoryCubit.state;
            String categoryTitle = '';
            if (state is ExerciseCategoryLoaded) {
              final category = state.categories.firstWhere((c) => c.id == _selectedCategoryId);
              categoryTitle = category.titleAr;
            }
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: _exerciseCubit,
                  child: AddEditExerciseScreen(
                    categoryId: _selectedCategoryId,
                    categoryTitle: categoryTitle,
                  ),
                ),
              ),
            ).then((value) {
              if (value == true) {
                _loadExercises();
              }
            });
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'إضافة تمرين',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return ExerciseCard(
      exercise: exercise,
      onEdit: () {
        final state = _categoryCubit.state;
        String categoryTitle = '';
        if (state is ExerciseCategoryLoaded) {
          final category = state.categories.firstWhere((c) => c.id == exercise.categoryId);
          categoryTitle = category.titleAr;
        }
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _exerciseCubit,
              child: AddEditExerciseScreen(
                categoryId: exercise.categoryId,
                categoryTitle: categoryTitle,
                exercise: exercise,
              ),
            ),
          ),
        ).then((value) {
          if (value == true) {
            _loadExercises();
          }
        });
      },
      onDelete: () => _showDeleteConfirmationDialog(context, exercise),
      onToggleFavorite: () => _exerciseCubit.toggleFavorite(exercise),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف التمرين'),
          content: const Text('هل أنت متأكد من رغبتك في حذف هذا التمرين؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                _exerciseCubit.deleteExercise(exercise);
                Navigator.of(context).pop();
                _loadExercises();
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
} 