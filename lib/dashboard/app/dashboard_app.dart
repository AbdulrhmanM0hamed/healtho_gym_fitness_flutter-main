import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/dashboard/presentation/screens/auth/dashboard_login_screen.dart';
import 'package:healtho_gym/dashboard/presentation/screens/dashboard_home_screen.dart';
import 'package:healtho_gym/core/theme/app_theme.dart';
import 'package:healtho_gym/dashboard/routes/dashboard_routes.dart';
import 'package:healtho_gym/dashboard/features/health_tip/presentation/viewmodels/health_tip_cubit.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/viewmodels/user_management_cubit.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_cubit.dart';

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HealthTipCubit>()),
        BlocProvider(create: (_) => sl<UserManagementCubit>()),
        BlocProvider(create: (_) => sl<ExerciseCategoryCubit>()),
        BlocProvider(create: (_) => sl<ExerciseCubit>()),
      ],
      child: DashboardHomeScreen(),
    );
  }
}
