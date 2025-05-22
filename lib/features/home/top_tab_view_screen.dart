import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/top_tab_button.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/setting/setting_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/challenges/challenges_tab_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/dietician/dietician_tab_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/exercises_tab_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/views/health_tip_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/profile/profile_tab_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/trainer/trainer_tab_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/screens/workout_plan_screen.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/user_profile_cubit/profile_cubit.dart';
import 'package:healtho_gym/core/services/one_signal_notification_service.dart';
import 'package:http/http.dart' as http;

class TopTabViewScreen extends StatefulWidget {
  const TopTabViewScreen({super.key});

  @override
  State<TopTabViewScreen> createState() => _TopTabViewScreenState();
}

class _TopTabViewScreenState extends State<TopTabViewScreen> with TickerProviderStateMixin {
  // Tab names
  var tapArr = [
    "نصائح صحية",
    "تمارين",
    "خطة تمرين",
    "تحديات",
    "مدربين",
    "الحساب"
  ];

  // Tab icons paths
  var tabIcons = [
    "assets/img/tab_bar/health_tips.svg",
    "assets/img/tab_bar/exercies.svg",
    "assets/img/tab_bar/exercies_plan.svg",
    "assets/img/tab_bar/challenge.svg",
    "assets/img/tab_bar/trenie.svg", 
    "assets/img/tab_bar/profile.svg",
  ];

  int selectTab = 0;

  // خدمة إشعارات OneSignal
  late OneSignalNotificationService _notificationService;

  // Create all screens once
  final List<Widget> _screens = [
    const HealthTipScreen(),
    const ExercisesScreen(),
    const WorkoutPlanScreen(),
    const ChallengesScreen(),
    const TrainerTabScreen(),
    const ProfileTabScreen(),
  ];

  @override
  void initState() {
    super.initState();
    
    // تهيئة خدمة الإشعارات
    _notificationService = sl<OneSignalNotificationService>();
  }

  // اختبار إرسال إشعار
  void _testNotification() async {
    try {
      await _notificationService.testNotification(
        "اختبار الإشعارات", 
        "هذا إشعار اختباري لتطبيق هيلثو جيم"
      );
      
      // محاولة إرسال إشعار عبر الخادم (إذا كان متاحًا)
      final isServerAvailable = await _checkServerAvailability();
      
      if (isServerAvailable) {
        // إذا كان الخادم متاحًا، أرسل الإشعار عبره
        await _notificationService.sendNotificationViaServer(
          "اختبار الإشعارات لجميع الأجهزة",
          "هذا إشعار اختباري لجميع مستخدمي تطبيق هيلثو جيم"
        );
        
        // تنبيه نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم إرسال إشعار لجميع الأجهزة عبر الخادم"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // عرض رسالة حول كيفية إعداد الخادم
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("لإرسال إشعارات للأجهزة الأخرى، يرجى تشغيل خادم الإشعارات"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
      }
      
    } catch (error) {
      print('خطأ في إرسال الإشعار الاختباري: $error');
      
      // تنبيه خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ أثناء إرسال الإشعار: $error"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  // التحقق من توفر خادم الإشعارات
  Future<bool> _checkServerAvailability() async {
    try {
      // محاولة الاتصال بالخادم
      final response = await http.get(
        Uri.parse('https://notification-server-production-befa.up.railway.app/'),
      ).timeout(const Duration(seconds: 2));
      
      return response.statusCode == 200;
    } catch (e) {
      print('خادم الإشعارات غير متاح: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<ProfileCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.secondary,
          centerTitle: false,
          leading: Container(),
          leadingWidth: 20,
          title: const Text(
            "Healtho",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            // زر اختبار الإشعارات
            IconButton(
              icon: const Icon(Icons.notifications_active, color: Colors.white),
              tooltip: 'اختبار الإشعارات',
              onPressed: _testNotification,
            ),
            // زر الإعدادات
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            //TODO: Top Tab Bar
            Container(
              margin: const EdgeInsets.only(top: 0.5),
              color: TColor.secondary,
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: tapArr.map((name) {
                      var index = tapArr.indexOf(name);

                      return TopTabButton(
                        title: name,
                        isSelect: selectTab == index,
                        iconPath: tabIcons[index],
                        onPressed: () {
                          setState(() {
                            selectTab = index;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            //TODO: Tab View
            // Use IndexedStack to preserve state
            Expanded(
              child: IndexedStack(
                index: selectTab,
                children: _screens,
              ),
            )
          ],
        ),
      ),
    );
  }
}
