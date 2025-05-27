import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common/custom_app_bar.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/screens/week_detail_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/screens/workout_introductions_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/viewmodels/workout_plan_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/week/week_detail_item.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final int planId;

  const WorkoutDetailScreen({
    Key? key,
    required this.planId,
  }) : super(key: key);

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutPlanCubit>()..getWorkoutPlanDetails(widget.planId),
      child: BlocBuilder<WorkoutPlanCubit, WorkoutPlanState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const CustomAppBar(
              title: "Workout Plan",
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
    } else if (state is WorkoutPlanDetailsLoaded) {
      final plan = state.plan;
      final weeks = state.weeks;
      
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(
                    plan.mainImageUrl,
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Container(
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "الهدف",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                plan.goal,
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "المدة",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${plan.durationWeeks} أسبوع",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "المستوى",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                plan.level,
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutIntroductionScreen(
                        planId: widget.planId,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "تفاصيل الخطة",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 20,
                      color: TColor.primaryText,
                    )
                  ],
                ),
              ),
              Text(
                plan.description,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 13,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 8,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: TColor.secondaryText.withOpacity(0.15),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 8,
                          width: (MediaQuery.of(context).size.width - 40) * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "30% اكتمال",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (weeks.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'لا توجد أسابيع متاحة لهذه الخطة.\nالرجاء المحاولة مرة أخرى لاحقاً.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: weeks.length,
                  itemBuilder: (context, index) {
                    final week = weeks[index];
                    return WeekDetailItem(
                      week: week,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeekDetailsScreen(weekId: week.id),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      );
    } else if (state is WorkoutWeekDaysLoaded) {
      // If we reached this state, it means we transitioned too quickly from loading plan details to loading week days
      // We return the user back and try to load plan details again
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading plan details. Please try again.'),
          ),
        );
      });
      return const Center(child: CircularProgressIndicator());
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Loading plan details...'),
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