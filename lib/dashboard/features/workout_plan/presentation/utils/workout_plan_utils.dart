import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// أدوات مساعدة لخطط التمرين
class WorkoutPlanUtils {
  /// تحويل التاريخ إلى نص مناسب للعرض
  static String formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// الحصول على اسم اليوم بالعربية
  static String getDayName(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return 'اليوم الأول';
      case 2:
        return 'اليوم الثاني';
      case 3:
        return 'اليوم الثالث';
      case 4:
        return 'اليوم الرابع';
      case 5:
        return 'اليوم الخامس';
      case 6:
        return 'اليوم السادس';
      case 7:
        return 'اليوم السابع';
      default:
        return 'اليوم $dayNumber';
    }
  }

  /// الحصول على اسم الأسبوع بالعربية
  static String getWeekName(int weekNumber) {
    switch (weekNumber) {
      case 1:
        return 'الأسبوع الأول';
      case 2:
        return 'الأسبوع الثاني';
      case 3:
        return 'الأسبوع الثالث';
      case 4:
        return 'الأسبوع الرابع';
      case 5:
        return 'الأسبوع الخامس';
      case 6:
        return 'الأسبوع السادس';
      case 7:
        return 'الأسبوع السابع';
      case 8:
        return 'الأسبوع الثامن';
      case 9:
        return 'الأسبوع التاسع';
      case 10:
        return 'الأسبوع العاشر';
      case 11:
        return 'الأسبوع الحادي عشر';
      case 12:
        return 'الأسبوع الثاني عشر';
      default:
        return 'الأسبوع $weekNumber';
    }
  }

  /// تحويل نص المستوى من الإنجليزية إلى العربية
  static String getLevelText(String level) {
    switch (level) {
      case 'beginner':
        return 'مبتدئ';
      case 'intermediate':
        return 'متوسط';
      case 'advanced':
        return 'متقدم';
      case 'expert':
        return 'محترف';
      default:
        return level;
    }
  }

  /// تحويل نص المستوى من العربية إلى الإنجليزية
  static String getLevelValue(String arabicLevel) {
    switch (arabicLevel) {
      case 'مبتدئ':
        return 'beginner';
      case 'متوسط':
        return 'intermediate';
      case 'متقدم':
        return 'advanced';
      case 'محترف':
        return 'expert';
      default:
        return arabicLevel;
    }
  }

  /// تحويل نص الجنس المستهدف من الإنجليزية إلى العربية
  static String getGenderText(String gender) {
    switch (gender) {
      case 'Male':
        return 'ذكر';
      case 'Female':
        return 'أنثى';
      case 'All':
        return 'الجميع';
      default:
        return gender;
    }
  }

  /// تحويل نص الجنس المستهدف من العربية إلى الإنجليزية
  static String getGenderValue(String arabicGender) {
    switch (arabicGender) {
      case 'ذكر':
        return 'Male';
      case 'أنثى':
        return 'Female';
      case 'الجميع':
        return 'All';
      default:
        return arabicGender;
    }
  }

  /// عرض رسالة نجاح
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// عرض رسالة خطأ
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// عرض مربع حوار للتأكيد
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    Color confirmColor = Colors.red,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: TextStyle(color: confirmColor),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// عرض مؤشر التحميل
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري التحميل...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// إغلاق مؤشر التحميل
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
