import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'workout_plan_state.dart';

class WorkoutPlanCubit extends Cubit<WorkoutPlanState> {
  WorkoutPlanCubit() : super(WorkoutPlanInitial());
}
