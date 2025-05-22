import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healtho_gym/core/utils/constants.dart';

class SupabaseClientProvider {
  static late final SupabaseClient _client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Constants.supabaseUrl,
      anonKey: Constants.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }
  
  static SupabaseClient get client => _client;
} 