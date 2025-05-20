import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/widgets/exercises_category_card.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/exercises_name_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/exercises_cubit.dart';

class ExercisesCategotiesGridVeiw extends StatelessWidget {
  final List<ExerciseCategory> categories;

  const ExercisesCategotiesGridVeiw({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return ExercisesCategoryCard(
          category: category,
          onPressed: () {
            print("DEBUG: Category cell pressed: ${category.titleAr}");
            final exercisesCubit = sl<ExercisesCubit>();
            exercisesCubit.loadExercisesByCategory(category);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: exercisesCubit,
                  child: const ExercisesNameScreen(),
                )
              )
            );
          }
        );
      },
    );
  }
}