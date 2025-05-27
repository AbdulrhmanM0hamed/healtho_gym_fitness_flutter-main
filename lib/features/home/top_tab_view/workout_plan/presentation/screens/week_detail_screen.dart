import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common/custom_app_bar.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/theme/app_colors.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/screens/day_exercises_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/viewmodels/workout_plan_cubit.dart';
import 'dart:ui';

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
            extendBodyBehindAppBar: true,
            appBar: CustomAppBar(
              title:  state is WorkoutWeekDaysLoaded
                    ? "Week ${state.week.weekNumber} Training"
                    : "Week Training",
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(WorkoutPlanState state) {
    if (state is WorkoutPlanLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'جاري تحميل تفاصيل الأسبوع...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    } else if (state is WorkoutPlanError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('العودة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.secondary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
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
                'لا توجد أيام تمرين متاحة لهذا الأسبوع.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                'الرجاء المحاولة مرة أخرى لاحقاً.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.secondary),
              ),
              const SizedBox(height: 24),
              RoundButton(
                title: "العودة",
                type: RoundButtonType.primary,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }

      // عرض معلومات الأسبوع في الأعلى
      return Column(
        children: [
          // ملخص الأسبوع
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
            child: Card(
              elevation: 8,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: TColor.secondary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.calendar_today,
                              color: TColor.secondary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Week ${state.week.weekNumber}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${state.days.length} training days",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: TColor.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.fitness_center,
                                  color: TColor.secondary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "${state.days.fold(0, (sum, day) => sum + day.totalExercises)} exercises",
                                style: TextStyle(
                                    color: TColor.secondary,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // قائمة أيام التمرين
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              itemBuilder: (context, index) {
                final day = state.days[index];
                return _buildDayCard(day);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: state.days.length,
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text(
            'جاري تحميل تفاصيل الأسبوع...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('العودة'),
            style: TextButton.styleFrom(foregroundColor: TColor.secondary),
          ),
        ],
      ),
    );
  }

  // بطاقة يوم تمرين محسنة
  Widget _buildDayCard(dynamic day) {
    final bool isRestDay = day.isRestDay;

    return Card(
      elevation: 5,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isRestDay
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DayExercisesScreen(dayId: day.id),
                  ),
                );
              },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isRestDay
                          ? Colors.blue[100]
                          : TColor.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isRestDay ? Icons.nightlight : Icons.fitness_center,
                      color: isRestDay ? Colors.blue[800] : TColor.secondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.dayName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (isRestDay)
                          Text(
                            "Rest Day - Recovery",
                            style: TextStyle(
                                color: Colors.blue[700], fontSize: 14),
                          )
                        else
                          Text(
                            "${day.totalExercises} exercises",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                  if (!isRestDay)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                ],
              ),
              if (!isRestDay) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildExerciseTypeInfo(
                      "Major",
                      day.majorExercises,
                      Colors.orange[700]!,
                    ),
                    const SizedBox(width: 24),
                    _buildExerciseTypeInfo(
                      "Minor",
                      day.minorExercises,
                      Colors.green[700]!,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // معلومات نوع التمرين (رئيسي/ثانوي)
  Widget _buildExerciseTypeInfo(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "$label: $count",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
