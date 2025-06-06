import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_category_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/presentation/widgets/exercises_category_card.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/exercises_name_screen.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List listArr = [
    {
      "title": "Bench Press",
      "subtitle": "5 Week",
      "image": "assets/img/c1.png"
    },
    {
      "title": "200 Situps",
      "subtitle": "10 Week",
      "image": "assets/img/c2.png"
    },
    {
      "title": "100 Pushups",
      "subtitle": "8 Week",
      "image": "assets/img/c3.png"
    },
    {"title": "300 Squats", "subtitle": "5 Week", "image": "assets/img/c4.png"},
    {"title": "Run 5 Km", "subtitle": "S Week", "image": "assets/img/c5.png"},
    {
      "title": "300 Pushups",
      "subtitle": "14 Week",
      "image": "assets/img/c6.png"
    },
    {
      "title": "200 Pushups",
      "subtitle": "10 Week",
      "image": "assets/img/c7.png"
    },
    {
      "title": "100 Pullups",
      "subtitle": "10 Week",
      "image": "assets/img/c8.png"
    },
  ];

  // دالة لتحليل عدد الأسابيع بشكل آمن
  int _parseWeekCount(String? subtitle) {
    if (subtitle == null || subtitle.isEmpty) {
      return 0;
    }
    
    // استخراج الجزء الأول من النص (قبل كلمة Week)
    final parts = subtitle.split(" ");
    if (parts.isEmpty) {
      return 0;
    }
    
    // محاولة تحويل النص إلى رقم
    try {
      return int.parse(parts.first);
    } catch (e) {
      // إذا لم يكن رقمًا، نرجع قيمة افتراضية
      return 4; // قيمة افتراضية لعدد الأسابيع
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15),
      itemBuilder: (context, index) {
  final data = listArr[index];
  final ExerciseCategory obj = ExerciseCategory(
    id: 1,
    title: data["title"] ?? "",
    titleAr: data["title"] ?? "", // استخدام title كقيمة لـ titleAr لعرض العنوان
    imageUrl: data["image"] ?? "",
    exercisesCount: _parseWeekCount(data["subtitle"]), // استخراج عدد الأسابيع بشكل آمن
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  return ExercisesCategoryCard(
    category: obj,
    onPressed: () {
    //  context.push(const WorkoutDetailScreen());
    },
  );
},

      itemCount: listArr.length,
    ));
  }
}
