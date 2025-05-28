import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common/custom_app_bar.dart';
import 'package:healtho_gym/core/theme/app_colors.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/widgets/exercises_card.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/exercises_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/workout_exercises_screen.dart';

class ExercisesNameScreen extends StatefulWidget {
  const ExercisesNameScreen({super.key});

  @override
  State<ExercisesNameScreen> createState() => _ExercisesNameScreenState();
}

class _ExercisesNameScreenState extends State<ExercisesNameScreen> {
  late ExercisesCubit _exercisesCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ الحصول على Cubit بعد بناء السياق
    _exercisesCubit = BlocProvider.of<ExercisesCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit, ExercisesState>(
        bloc: _exercisesCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
             backgroundColor: TColor.secondary,
             leading: const Icon(Icons.arrow_back_ios_new , color: AppColors.white),
              title: state is ExercisesLoaded && state.category != null
                  ? state.category!.titleAr
                  : 'تمارين',
           titleColor: AppColors.white,
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0.5),
                  width: double.maxFinite,
                  color: TColor.secondary,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: TColor.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                width: 50,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/img/down_white.png",
                                  width: 15,
                                ),
                              ),
                            ),
                            hint: const Text(
                              "اختر المستوى",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            dropdownColor:
                                TColor.secondary, // لون خلفية القائمة المنسدلة
                            style: const TextStyle(
                              color:
                                  Colors.white, // لون النص في القائمة المنسدلة
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            value: state is ExercisesLoaded
                                ? "Level ${state.selectedLevel}"
                                : null,
                            items: ["Level 1", "Level 2", "Level 3"]
                                .map(
                                  (obj) => DropdownMenuItem(
                                    value: obj,
                                    child: Text(
                                      obj,
                                      style: const TextStyle(
                                        color:
                                            Colors.white, // لون النص في العناصر
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                final level = int.parse(value.split(' ')[1]);
                                _exercisesCubit.setLevel(level);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: state is ExercisesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is ExercisesError
                          ? Center(child: Text('خطأ: ${state.message}'))
                          : state is ExercisesLoaded && state.exercises.isEmpty
                              ? Center(
                                  child: Text(
                                      'لا توجد تمارين في هذا المستوى (الفئة: ${state.category?.titleAr}, المستوى: ${state.selectedLevel})'),
                                )
                              : state is ExercisesLoaded
                                  ? ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      itemBuilder: (context, index) {
                                        final exercise = state.exercises[index];
                                        return ExercisesCard(
                                          exercise: exercise,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WorkoutExercisesDetailScreen(
                                                          exercise: exercise,
                                                          onToggleFavorite: () {
                                                            _exercisesCubit
                                                                .toggleFavorite(
                                                                    exercise);
                                                          },
                                                        )));
                                          },
                                          onToggleFavorite: () {
                                            _exercisesCubit
                                                .toggleFavorite(exercise);
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 20),
                                      itemCount: state.exercises.length)
                                  : const Center(
                                      child: Text('اختر فئة لعرض التمارين')),
                ),
              ],
            ),
          );
        });
  }
}
