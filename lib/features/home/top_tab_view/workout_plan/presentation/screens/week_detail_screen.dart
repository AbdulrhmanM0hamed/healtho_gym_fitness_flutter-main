import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/screens/day_exercises_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/viewmodels/workout_plan_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/day/workout_day_card.dart';

class WeekDetailsScreen extends StatefulWidget {
  final int weekId;

  const WeekDetailsScreen({
    Key? key,
    required this.weekId,
  }) : super(key: key);

  @override
  State<WeekDetailsScreen> createState() => _WeekDetailsScreenState();
}

class _WeekDetailsScreenState extends State<WeekDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutPlanCubit>()..loadWeekDays(widget.weekId),
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
              title: Text(
                state is WorkoutWeekDaysLoaded
                    ? "Week ${state.week.weekNumber}"
                    : "Week",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
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
    } else if (state is WorkoutWeekDaysLoaded) {
      if (state.days.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'لا توجد أيام تمرين متاحة لهذا الأسبوع.\nالرجاء المحاولة مرة أخرى لاحقاً.',
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
          final day = state.days[index];
          return WorkoutDayCard(
            dayName: day.dayName,
            totalExercises: day.totalExercises,
            majorExercises: day.majorExercises,
            minorExercises: day.minorExercises,
            isRestDay: day.isRestDay,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DayExercisesScreen(dayId: day.id),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: state.days.length,
      );
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('جاري تحميل تفاصيل الأسبوع...'),
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