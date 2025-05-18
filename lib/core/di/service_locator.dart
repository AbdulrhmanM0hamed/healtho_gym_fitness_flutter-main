import 'package:get_it/get_it.dart';
import 'package:healtho_gym/features/login/data/repositories/auth_repository.dart';
import 'package:healtho_gym/features/login/data/repositories/user_profile_repository.dart';
import 'package:healtho_gym/core/services/auth_service.dart';
import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/core/services/user_profile_service.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/user_profile_cubit/profile_cubit.dart';

final GetIt sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Initialize Supabase before registering any dependencies
    await SupabaseService.initialize();

    // Register services
    sl.registerLazySingleton<AuthService>(() => AuthService());
    sl.registerLazySingleton<UserProfileService>(() => UserProfileService());

    // Register repositories
    sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
    sl.registerLazySingleton<UserProfileRepository>(() => UserProfileRepository());

    // Register cubits
    sl.registerLazySingleton<AuthCubit>(() => AuthCubit());
    sl.registerFactory<ProfileCubit>(() => ProfileCubit());
  }
} 