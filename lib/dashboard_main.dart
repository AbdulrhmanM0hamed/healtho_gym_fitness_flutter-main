import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healtho_gym/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/app/dashboard_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize service locator
  await ServiceLocator.init();
  
  runApp(const DashboardApp());
} 