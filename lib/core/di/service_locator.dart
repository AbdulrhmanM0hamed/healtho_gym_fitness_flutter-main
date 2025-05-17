import 'package:get_it/get_it.dart';
import 'package:healtho_gym/repositories/auth_repository.dart';
import 'package:healtho_gym/repositories/user_profile_repository.dart';
import 'package:healtho_gym/services/auth_service.dart';
import 'package:healtho_gym/services/supabase_service.dart';
import 'package:healtho_gym/services/user_profile_service.dart';
import 'package:healtho_gym/viewmodels/auth_view_model.dart';
import 'package:healtho_gym/viewmodels/user_profile_view_model.dart';

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