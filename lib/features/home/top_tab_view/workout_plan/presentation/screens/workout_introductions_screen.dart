import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/viewmodels/workout_plan_cubit.dart';

class WorkoutIntroductionScreen extends StatefulWidget {
  final int planId;

  const WorkoutIntroductionScreen({
    Key? key,
    required this.planId,
  }) : super(key: key);

  @override
  State<WorkoutIntroductionScreen> createState() => _WorkoutIntroductionScreenState();
}

class _WorkoutIntroductionScreenState extends State<WorkoutIntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutPlanCubit>()..getWorkoutPlanDetails(widget.planId),
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
                state is WorkoutPlanDetailsLoaded ? state.plan.title : 'Introduction',
                style: const TextStyle(color: Colors.white),
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
      return Center(child: Text(state.message));
    } else if (state is WorkoutPlanDetailsLoaded) {
      final plan = state.plan;
      final weeks = state.weeks;
      
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  plan.mainImageUrl,
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'About This Plan',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                plan.description,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Plan Details',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildDetailRow('Goal', plan.goal),
              _buildDetailRow('Level', plan.level),
              _buildDetailRow('Duration', '${plan.durationWeeks} Weeks'),
              _buildDetailRow('Total Weeks', weeks.length.toString()),
            ],
          ),
        ),
      );
    }
    
    return const Center(child: Text('Loading introduction...'));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
} 