import 'package:get_it/get_it.dart';
import 'package:healtho_gym/features/login/data/repositories/auth_repository.dart';
import 'package:healtho_gym/features/login/data/repositories/user_profile_repository.dart';
import 'package:healtho_gym/core/services/auth_service.dart';
import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/core/services/user_profile_service.dart';
import 'package:healtho_gym/dashboard/core/service/health_tip_service.dart';
import 'package:healtho_gym/dashboard/features/user/data/repositories/user_management_repository.dart';
import 'package:healtho_gym/dashboard/features/user/data/services/user_management_service.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/viewmodels/user_management_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/user_profile_cubit/profile_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/repositories/health_tip_repository.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_cubit.dart';
import 'package:healtho_gym/dashboard/features/health_tip/presentation/viewmodels/health_tip_cubit.dart' as dashboard;

final GetIt sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Initialize Supabase service
    await SupabaseService.initialize();
    
    // Core services
    sl.registerLazySingleton<AuthService>(() => AuthService());
    sl.registerLazySingleton<UserProfileService>(() => UserProfileService());
    sl.registerLazySingleton<HealthTipService>(() => HealthTipService());
    sl.registerLazySingleton<UserManagementService>(() => UserManagementService());
    
    // Repositories
    sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
    sl.registerLazySingleton<UserProfileRepository>(() => UserProfileRepository());
    sl.registerLazySingleton<HealthTipRepository>(() => HealthTipRepository(sl()));
    sl.registerLazySingleton<UserManagementRepository>(() => UserManagementRepository());
    
    // Cubits & ViewModels
    sl.registerFactory<AuthCubit>(() => AuthCubit());
    sl.registerFactory<ProfileCubit>(() => ProfileCubit());
    sl.registerFactory<HealthTipCubit>(() => HealthTipCubit(sl()));
    sl.registerFactory<dashboard.HealthTipCubit>(() => dashboard.HealthTipCubit());
    sl.registerLazySingleton<UserManagementCubit>(() => UserManagementCubit());
  }
} 