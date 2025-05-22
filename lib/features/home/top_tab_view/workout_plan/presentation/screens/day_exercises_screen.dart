import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/workout_exercises_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/viewmodels/workout_plan_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/exercise/day_exercise_card.dart';

class DayExercisesScreen extends StatefulWidget {
  final int dayId;

  const DayExercisesScreen({
    Key? key,
    required this.dayId,
  }) : super(key: key);

  @override
  State<DayExercisesScreen> createState() => _DayExercisesScreenState();
}

class _DayExercisesScreenState extends State<DayExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutPlanCubit>()..loadDayExercises(widget.dayId),
      child: BlocBuilder<WorkoutPlanCubit, WorkoutPlanState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "assets/img/back.png",
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ),
              backgroundColor: TColor.secondary,
              centerTitle: false,
              title: const Text(
                "Day Exercises",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Reset all exercises completion status
                    // TODO: Implement reset functionality
                  },
                  child: const Text(
                    "Reset",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }
  
  Widget _buildBody(WorkoutPlanState state) {
    if (state is WorkoutPlanLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WorkoutPlanError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('العودة'),
            ),
          ],
        ),
      );
    } else if (state is WorkoutDayExercisesLoaded) {
      if (state.exercises.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'لا توجد تمارين متاحة لهذا اليوم.\nالرجاء المحاولة مرة أخرى لاحقاً.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('العودة'),
              ),
            ],
          ),
        );
      }
      
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        itemBuilder: (context, index) {
          final dayExercise = state.exercises[index];
          
          // Convert DayExerciseModel to Exercise model
          final exercise = Exercise(
            id: dayExercise.exerciseId,
            categoryId: 0, // Not needed for display
            title: dayExercise.exerciseName,
            description: '', // Will be loaded in detail screen
            mainImageUrl: dayExercise.exerciseImage,
            level: 1, // Not needed for display
            isFavorite: false, // Not needed for display
            createdAt: dayExercise.createdAt,
            updatedAt: dayExercise.updatedAt,
            imageUrl: [], // Will be loaded in detail screen
          );

          return DayExerciseCard(
            name: dayExercise.exerciseName,
            sets: dayExercise.sets.toString(),
            reps: dayExercise.reps,
            restTime: dayExercise.restTime,
            imageUrl: dayExercise.exerciseImage,
            isCompleted: dayExercise.isCompleted,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutExercisesDetailScreen(
                    exercise: exercise,
                    onToggleFavorite: () {
                      context.read<WorkoutPlanCubit>().toggleExerciseCompletion(
                            dayExercise.id,
                            !dayExercise.isCompleted,
                          );
                    },
                  ),
                ),
              );
            },
            onToggleComplete: () {
              context.read<WorkoutPlanCubit>().toggleExerciseCompletion(
                    dayExercise.id,
                    !dayExercise.isCompleted,
                  );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: state.exercises.length,
      );
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('جاري تحميل تمارين اليوم...'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('العودة'),
          ),
        ],
      ),
    );
  }
} 