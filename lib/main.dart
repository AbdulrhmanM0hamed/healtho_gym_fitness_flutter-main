import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healtho_gym/firebase_options.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/preferences/app_preferences.dart';
import 'package:healtho_gym/core/routes/app_routes.dart';
import 'package:healtho_gym/core/theme/app_theme.dart';
import 'package:healtho_gym/dashboard/app/dashboard_app.dart';
import 'package:healtho_gym/features/splash/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:healtho_gym/core/services/one_signal_notification_service.dart';

// To use the dashboard, comment out this line and uncomment the next line
// void main() async {
//   mainMobile();
// }

// To use the dashboard, uncomment this line and comment out the previous main
void main() async {
  mainMobile();
}

// Mobile application entry point
void mainMobile() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // تهيئة OneSignal
  _initOneSignal();
  // Initialize Preferences
  await AppPreferences().init();
  // Initialize ServiceLocator
  await ServiceLocator.init();
  runApp(
    const MyApp(),
  );
}

// تهيئة OneSignal
void _initOneSignal() {
  // إعداد مستوى السجل للتصحيح
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  // تهيئة OneSignal بمعرف التطبيق
  OneSignal.initialize("897f8d3f-91cb-4fd1-b5f9-570e9c73cfe6");

  // طلب إذن الإشعارات
  try {
    OneSignal.Notifications.requestPermission(true);
  } catch (e) {
    print("خطأ في طلب أذونات الإشعارات: $e");
    // استمر رغم الخطأ
  }

  // إعداد معالج النقر على الإشعارات
  try {
    OneSignal.Notifications.addClickListener((event) {
      print(
          "تم النقر على إشعار OneSignal: ${event.notification.additionalData}");
    });
  } catch (e) {
    print("خطأ في إضافة مستمع النقر على الإشعارات: $e");
  }

  // إضافة تأخير قبل تهيئة خدمة الإشعارات المخصصة
  // للسماح لـ OneSignal بالتسجيل أولاً
  Future.delayed(const Duration(seconds: 3), () {
    // تهيئة خدمة الإشعارات المخصصة
    OneSignalNotificationService();
    print("تم تهيئة خدمة الإشعارات المخصصة بعد تأخير");
  });
}

// Dashboard application entry point
void mainDashboard() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize ServiceLocator
  await ServiceLocator.init();

  // This would be a better approach but requires importing the dashboard directly
  // runApp(const DashboardApp());

  // Instead, for now, show a message telling the user to use dashboard_main.dart
  runApp(const DashboardApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healtho Gym',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Always start with splash screen
      home: const SplashScreen(),
      // Use the routes defined in AppRoutes
      routes: AppRoutes.routes,
      // Use the onGenerateRoute from AppRoutes
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
