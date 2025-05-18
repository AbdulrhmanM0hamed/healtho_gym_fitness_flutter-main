import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healtho_gym/core/config/supabase_config.dart';
import 'package:healtho_gym/core/utils/logger_util.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;
  
  SupabaseService._() {
    _client = SupabaseClient(
      SupabaseConfig.apiUrl, 
      SupabaseConfig.apiKey
    );
    LoggerUtil.info('Supabase client initialized');
  }
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.apiUrl,
      anonKey: SupabaseConfig.apiKey,
    );
    LoggerUtil.info('Supabase initialized');
  }
  
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }
  
  SupabaseClient get client => _client;
  
  static SupabaseClient get supabase => Supabase.instance.client;
} 