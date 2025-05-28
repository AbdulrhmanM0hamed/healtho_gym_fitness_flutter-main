import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healtho_gym/dashboard/features/exercise/data/repositories/exercise_repository.dart' as dashboard_exercise;
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/data/repositories/exercise_category_repository.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_cubit.dart';
import 'package:healtho_gym/dashboard/features/health_tip/data/repositories/health_tip_repository.dart' as dashboard_health_tip;
import 'package:healtho_gym/dashboard/features/health_tip/presentation/viewmodels/health_tip_cubit.dart' as dashboard_health_tip_cubit;
import 'package:healtho_gym/dashboard/features/user/data/repositories/user_management_repository.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/viewmodels/user_management_cubit.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/repositories/dashboard_workout_plan_repository.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/repositories/dashboard_workout_plan_repository_impl.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/repositories/exercise_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/exercises_category_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/exercises_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/datasources/custom_exercise_local_datasource.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/cubits/custom_exercises_cubit.dart';
import 'package:healtho_gym/features/login/data/repositories/auth_repository.dart';
import 'package:healtho_gym/features/login/data/repositories/user_profile_repository.dart';
import 'package:healtho_gym/core/services/auth_service.dart';
import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/core/services/user_profile_service.dart';
import 'package:healtho_gym/dashboard/core/service/health_tip_service.dart';
import 'package:healtho_gym/dashboard/features/user/data/services/user_management_service.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/user_profile_cubit/profile_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/repositories/health_tip_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_cubit.dart';
import 'package:healtho_gym/core/services/one_signal_notification_service.dart';
import 'package:healtho_gym/core/services/storage_service.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/datasources/workout_plan_remote_data_source.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/repositories/workout_plan_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/repositories/filters_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/viewmodels/workout_plan_cubit.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Initialize Supabase service
    await SupabaseService.initialize();

    // Core services
    sl.registerLazySingleton<AuthService>(() => AuthService());
    sl.registerLazySingleton<UserProfileService>(() => UserProfileService());
    sl.registerLazySingleton<HealthTipService>(() => HealthTipService());
    sl.registerLazySingleton<UserManagementService>(() => UserManagementService());
    sl.registerLazySingleton<StorageService>(() => StorageService());

    // Register notification service
    sl.registerLazySingleton<OneSignalNotificationService>(() => OneSignalNotificationService());

    // Register repositories
    sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
    sl.registerLazySingleton<UserProfileRepository>(() => UserProfileRepository());
    sl.registerLazySingleton<HealthTipRepository>(() => HealthTipRepository(sl()));
    sl.registerLazySingleton<dashboard_health_tip.HealthTipRepository>(() => dashboard_health_tip.HealthTipRepository());
    sl.registerLazySingleton<UserManagementRepository>(() => UserManagementRepository());
    sl.registerLazySingleton<ExerciseRepository>(() => ExerciseRepository());
    
    // Dashboard repositories
    sl.registerLazySingleton<ExerciseCategoryRepository>(() => ExerciseCategoryRepository());
    sl.registerLazySingleton<dashboard_exercise.ExerciseRepository>(() => dashboard_exercise.ExerciseRepository());
    // تسجيل مستودع خطط التمرين
    sl.registerLazySingleton<DashboardWorkoutPlanRepositoryImpl>(() => DashboardWorkoutPlanRepositoryImpl());
    sl.registerLazySingleton<DashboardWorkoutPlanRepository>(
      () => sl<DashboardWorkoutPlanRepositoryImpl>(),
    );

    // Workout Plan dependencies
    sl.registerLazySingleton<WorkoutPlanRemoteDataSource>(
      () => WorkoutPlanRemoteDataSource(Supabase.instance.client),
    );
    sl.registerLazySingleton(() => WorkoutPlanRepository(sl<WorkoutPlanRemoteDataSource>()));
    sl.registerLazySingleton(() => FiltersRepository(sl<SupabaseClient>()));
    sl.registerFactory<WorkoutPlanCubit>(
      () => WorkoutPlanCubit(sl()),
    );

    // Register cubits
    sl.registerFactory<AuthCubit>(() => AuthCubit());
    sl.registerFactory<ProfileCubit>(() => ProfileCubit());
    sl.registerFactory<HealthTipCubit>(() => HealthTipCubit(sl()));
    sl.registerFactory<dashboard_health_tip_cubit.HealthTipCubit>(() => dashboard_health_tip_cubit.HealthTipCubit());
    sl.registerFactory<UserManagementCubit>(() => UserManagementCubit());

    // Exercises
    sl.registerFactory<ExercisesCubit>(() => ExercisesCubit(sl()));
    sl.registerFactory<ExercisesCategoryCubit>(() => ExercisesCategoryCubit(sl()));
    
    // Custom Exercises
    sl.registerLazySingleton<CustomExerciseLocalDataSource>(() => CustomExerciseLocalDataSource());
    sl.registerFactory<CustomExercisesCubit>(() => CustomExercisesCubit(sl(), sl()));

    // Exercise cubits (dashboard)
    sl.registerFactory<ExerciseCategoryCubit>(() => ExerciseCategoryCubit(sl(), sl<StorageService>()));
    sl.registerFactory<ExerciseCubit>(() => ExerciseCubit(sl(), sl<StorageService>()));
    sl.registerFactory<DashboardWorkoutPlanCubit>(() => DashboardWorkoutPlanCubit(sl()));

    await _initThirdPartyServices();
  }

  // Initialize third-party services
  static Future<void> _initThirdPartyServices() async {
    // Initialize third-party services here if needed
  }
}
