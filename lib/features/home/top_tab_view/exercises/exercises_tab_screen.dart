import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/exercises_category_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/widgets/exercises_categoties_grid_veiw.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  late ExercisesCategoryCubit _categoryCubit;

  @override
  void initState() {
    super.initState();
    _categoryCubit = sl<ExercisesCategoryCubit>();
    _categoryCubit.loadCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _categoryCubit.loadCategories();
        },
        child: BlocBuilder<ExercisesCategoryCubit, ExercisesCategoryState>(
          bloc: _categoryCubit,
          builder: (context, state) {
            if (state is ExercisesCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExercisesCategoryError) {
              return Center(child: Text(state.message));
            } else if (state is ExercisesCategoryLoaded) {
              return ExercisesCategotiesGridVeiw(categories: state.categories);
            } else {
              return const Center(child: Text('لا توجد فئات'));
            }
          }
        ),
      )
    );
  }
}



