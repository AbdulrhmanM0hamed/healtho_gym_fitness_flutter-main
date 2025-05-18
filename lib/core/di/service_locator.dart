import 'package:get_it/get_it.dart';
import 'package:healtho_gym/repositories/auth_repository.dart';
import 'package:healtho_gym/repositories/user_profile_repository.dart';
import 'package:healtho_gym/core/services/auth_service.dart';
import 'package:healtho_gym/core/services/supabase_service.dart';
import 'package:healtho_gym/core/services/user_profile_service.dart';
import 'package:healtho_gym/screen/login/viewmodels/auth_view_model.dart';
import 'package:healtho_gym/screen/login/viewmodels/user_profile_view_model.dart';

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

    // Register view models
    sl.registerFactory<AuthViewModel>(() => AuthViewModel());
    sl.registerFactory<UserProfileViewModel>(() => UserProfileViewModel());
  }
} 