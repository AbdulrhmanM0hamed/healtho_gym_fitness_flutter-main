import 'package:flutter/material.dart';
import 'package:healtho_gym/core/theme/app_colors.dart';
import 'package:healtho_gym/core/theme/custom_themes/text_theme.dart';

/// ثيم خاص بخطط التمرين
class WorkoutPlanTheme {
  // الألوان الرئيسية
  static const Color primaryColor = AppColors.primary;
  static const Color secondaryColor = AppColors.secondary;
  static const Color accentColor = AppColors.accent;
  static const Color errorColor = AppColors.error;
  static const Color successColor = AppColors.success;
  static const Color warningColor = AppColors.warning;
  static const Color backgroundColor = AppColors.scaffoldBackground;
  static const Color cardColor = AppColors.cardBackground;
  static const Color textPrimaryColor = AppColors.textPrimary;
  static const Color textSecondaryColor = AppColors.textSecondary;
  static const Color dividerColor = AppColors.divider;

  // ألوان المستويات
  static const Color beginnerColor = AppColors.success; // أخضر
  static const Color intermediateColor = AppColors.warning; // أصفر
  static const Color advancedColor = AppColors.accent; // برتقالي
  static const Color expertColor = AppColors.error; // أحمر

  // أنماط النصوص - مستوحاة من ثيم التطبيق الرئيسي
  static TextStyle get headingStyle => TTextTheme.lightTextTheme.headlineMedium!.copyWith(
        color: textPrimaryColor,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get subheadingStyle => TTextTheme.lightTextTheme.titleLarge!.copyWith(
        color: textPrimaryColor,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleStyle => TTextTheme.lightTextTheme.titleMedium!.copyWith(
        color: textPrimaryColor,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyStyle => TTextTheme.lightTextTheme.bodyMedium!.copyWith(
        color: textPrimaryColor,
      );

  static TextStyle get captionStyle => TTextTheme.lightTextTheme.bodySmall!.copyWith(
        color: textSecondaryColor,
      );

  // أنماط الأزرار - مستوحاة من ثيم التطبيق الرئيسي
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      );

  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );

  // أنماط البطاقات - مستوحاة من ثيم التطبيق الرئيسي
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get cardDecorationHover => BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      );

  // أنماط حقول الإدخال - مستوحاة من ثيم التطبيق الرئيسي
  static InputDecoration get inputDecoration => InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );

  // الحصول على لون المستوى حسب النص
  static Color getLevelColor(String level) {
    switch (level) {
      case 'beginner':
      case 'مبتدئ':
        return beginnerColor;
      case 'intermediate':
      case 'متوسط':
        return intermediateColor;
      case 'advanced':
      case 'متقدم':
        return advancedColor;
      case 'expert':
      case 'محترف':
        return expertColor;
      default:
        return beginnerColor;
    }
  }

  // الحصول على لون الجنس المستهدف
  static Color getGenderColor(String gender) {
    switch (gender) {
      case 'Male':
      case 'ذكر':
        return Colors.blue;
      case 'Female':
      case 'أنثى':
        return Colors.pink;
      default:
        return Colors.purple;
    }
  }
}
