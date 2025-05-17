import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const _localizedValues = {
    'en': {
      // Common
      'app_name': 'Healtho Gym',
      'next': 'Next',
      'skip': 'Skip',
      'get_started': 'Get Started',
      'continue_text': 'Continue',
      'submit': 'Submit',
      'save': 'Save',
      'cancel': 'Cancel',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Information',
      'loading': 'Loading...',
      'retry': 'Retry',
      
      // Authentication
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'sign_out': 'Sign Out',
      'email': 'Email Address',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'forgot_password': 'Forgot Password?',
      'reset_password': 'Reset Password',
      'create_account': 'Create an Account',
      'already_have_account': 'Already have an account?',
      'dont_have_account': 'Don\'t have an account?',
      'or_continue_with': 'Or continue with',
      'welcome_back': 'Welcome Back!',
      'sign_in_to_continue': 'Sign in to continue',
      'fill_details': 'Fill in your details to get started',
      
      // Onboarding
      'onboarding_title_1': 'Welcome to Healtho Gym',
      'onboarding_desc_1': 'Your personal fitness companion for a healthier lifestyle.',
      'onboarding_title_2': 'Personalized Workouts',
      'onboarding_desc_2': 'Get customized workout plans based on your fitness goals and level.',
      'onboarding_title_3': 'Track Your Progress',
      'onboarding_desc_3': 'Monitor your fitness journey with detailed stats and insights.',
      
      // Home
      'home': 'Home',
      'workouts': 'Workouts',
      'nutrition': 'Nutrition',
      'progress': 'Progress',
      'profile': 'Profile',
      'today_workout': 'Today\'s Workout',
      'view_all': 'View All',
      'workout_stats': 'Workout Stats',
      'calories_burned': 'Calories Burned',
      'workout_duration': 'Workout Duration',
      'workout_completed': 'Workouts Completed',
      
      // Profile
      'personal_info': 'Personal Information',
      'height': 'Height',
      'weight': 'Weight',
      'age': 'Age',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'fitness_level': 'Fitness Level',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'fitness_goal': 'Fitness Goal',
      'weight_loss': 'Weight Loss',
      'muscle_gain': 'Muscle Gain',
      'general_fitness': 'General Fitness',
      'settings': 'Settings',
      'update_profile': 'Update Profile',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'notifications': 'Notifications',
      'logout': 'Logout',
      
      // Messages
      'login_success': 'Login successful!',
      'login_failed': 'Login failed. Please check your credentials.',
      'signup_success': 'Account created successfully!',
      'signup_failed': 'Failed to create account. Please try again.',
      'password_reset_sent': 'Password reset instructions sent to your email.',
      'fill_all_fields': 'Please fill in all required fields.',
      'passwords_dont_match': 'Passwords do not match.',
      'network_error': 'Network error. Please check your connection.',
    },
    'ar': {
      // Common
      'app_name': 'صحتك جيم',
      'next': 'التالي',
      'skip': 'تخطي',
      'get_started': 'ابدأ الآن',
      'continue_text': 'استمرار',
      'submit': 'إرسال',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'موافق',
      'error': 'خطأ',
      'success': 'تم بنجاح',
      'warning': 'تحذير',
      'info': 'معلومات',
      'loading': 'جاري التحميل...',
      'retry': 'إعادة المحاولة',
      
      // Authentication
      'sign_in': 'تسجيل الدخول',
      'sign_up': 'إنشاء حساب',
      'sign_out': 'تسجيل الخروج',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'full_name': 'الاسم الكامل',
      'forgot_password': 'نسيت كلمة المرور؟',
      'reset_password': 'إعادة تعيين كلمة المرور',
      'create_account': 'إنشاء حساب جديد',
      'already_have_account': 'لديك حساب بالفعل؟',
      'dont_have_account': 'ليس لديك حساب؟',
      'or_continue_with': 'أو تابع باستخدام',
      'welcome_back': 'مرحبًا بعودتك!',
      'sign_in_to_continue': 'سجل دخولك للمتابعة',
      'fill_details': 'املأ بياناتك للبدء',
      
      // Onboarding
      'onboarding_title_1': 'مرحبًا بك في صحتك جيم',
      'onboarding_desc_1': 'رفيقك الشخصي للياقة البدنية من أجل نمط حياة أكثر صحة.',
      'onboarding_title_2': 'تمارين مخصصة',
      'onboarding_desc_2': 'احصل على خطط تدريبية مخصصة بناءً على أهدافك ومستواك البدني.',
      'onboarding_title_3': 'تتبع تقدمك',
      'onboarding_desc_3': 'راقب رحلتك في اللياقة البدنية مع إحصاءات ورؤى تفصيلية.',
      
      // Home
      'home': 'الرئيسية',
      'workouts': 'التمارين',
      'nutrition': 'التغذية',
      'progress': 'التقدم',
      'profile': 'الملف الشخصي',
      'today_workout': 'تمارين اليوم',
      'view_all': 'عرض الكل',
      'workout_stats': 'إحصائيات التمارين',
      'calories_burned': 'السعرات الحرارية المحروقة',
      'workout_duration': 'مدة التمرين',
      'workout_completed': 'التمارين المكتملة',
      
      // Profile
      'personal_info': 'المعلومات الشخصية',
      'height': 'الطول',
      'weight': 'الوزن',
      'age': 'العمر',
      'gender': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'fitness_level': 'مستوى اللياقة',
      'beginner': 'مبتدئ',
      'intermediate': 'متوسط',
      'advanced': 'متقدم',
      'fitness_goal': 'هدف اللياقة',
      'weight_loss': 'فقدان الوزن',
      'muscle_gain': 'بناء العضلات',
      'general_fitness': 'لياقة عامة',
      'settings': 'الإعدادات',
      'update_profile': 'تحديث الملف الشخصي',
      'dark_mode': 'الوضع الداكن',
      'language': 'اللغة',
      'notifications': 'الإشعارات',
      'logout': 'تسجيل الخروج',
      
      // Messages
      'login_success': 'تم تسجيل الدخول بنجاح!',
      'login_failed': 'فشل تسجيل الدخول. يرجى التحقق من بياناتك.',
      'signup_success': 'تم إنشاء الحساب بنجاح!',
      'signup_failed': 'فشل إنشاء الحساب. يرجى المحاولة مرة أخرى.',
      'password_reset_sent': 'تم إرسال تعليمات إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
      'fill_all_fields': 'يرجى ملء جميع الحقول المطلوبة.',
      'passwords_dont_match': 'كلمات المرور غير متطابقة.',
      'network_error': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
    },
  };
  
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get next => _localizedValues[locale.languageCode]!['next']!;
  String get skip => _localizedValues[locale.languageCode]!['skip']!;
  String get getStarted => _localizedValues[locale.languageCode]!['get_started']!;
  String get continueText => _localizedValues[locale.languageCode]!['continue_text']!;
  String get submit => _localizedValues[locale.languageCode]!['submit']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get yes => _localizedValues[locale.languageCode]!['yes']!;
  String get no => _localizedValues[locale.languageCode]!['no']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get warning => _localizedValues[locale.languageCode]!['warning']!;
  String get info => _localizedValues[locale.languageCode]!['info']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  
  // Authentication
  String get signIn => _localizedValues[locale.languageCode]!['sign_in']!;
  String get signUp => _localizedValues[locale.languageCode]!['sign_up']!;
  String get signOut => _localizedValues[locale.languageCode]!['sign_out']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get confirmPassword => _localizedValues[locale.languageCode]!['confirm_password']!;
  String get fullName => _localizedValues[locale.languageCode]!['full_name']!;
  String get forgotPassword => _localizedValues[locale.languageCode]!['forgot_password']!;
  String get resetPassword => _localizedValues[locale.languageCode]!['reset_password']!;
  String get createAccount => _localizedValues[locale.languageCode]!['create_account']!;
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]!['already_have_account']!;
  String get dontHaveAccount => _localizedValues[locale.languageCode]!['dont_have_account']!;
  String get orContinueWith => _localizedValues[locale.languageCode]!['or_continue_with']!;
  String get welcomeBack => _localizedValues[locale.languageCode]!['welcome_back']!;
  String get signInToContinue => _localizedValues[locale.languageCode]!['sign_in_to_continue']!;
  String get fillDetails => _localizedValues[locale.languageCode]!['fill_details']!;
  
  // Onboarding
  String get onboardingTitle1 => _localizedValues[locale.languageCode]!['onboarding_title_1']!;
  String get onboardingDesc1 => _localizedValues[locale.languageCode]!['onboarding_desc_1']!;
  String get onboardingTitle2 => _localizedValues[locale.languageCode]!['onboarding_title_2']!;
  String get onboardingDesc2 => _localizedValues[locale.languageCode]!['onboarding_desc_2']!;
  String get onboardingTitle3 => _localizedValues[locale.languageCode]!['onboarding_title_3']!;
  String get onboardingDesc3 => _localizedValues[locale.languageCode]!['onboarding_desc_3']!;
  
  // Home
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get workouts => _localizedValues[locale.languageCode]!['workouts']!;
  String get nutrition => _localizedValues[locale.languageCode]!['nutrition']!;
  String get progress => _localizedValues[locale.languageCode]!['progress']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get todayWorkout => _localizedValues[locale.languageCode]!['today_workout']!;
  String get viewAll => _localizedValues[locale.languageCode]!['view_all']!;
  String get workoutStats => _localizedValues[locale.languageCode]!['workout_stats']!;
  String get caloriesBurned => _localizedValues[locale.languageCode]!['calories_burned']!;
  String get workoutDuration => _localizedValues[locale.languageCode]!['workout_duration']!;
  String get workoutCompleted => _localizedValues[locale.languageCode]!['workout_completed']!;
  
  // Profile
  String get personalInfo => _localizedValues[locale.languageCode]!['personal_info']!;
  String get height => _localizedValues[locale.languageCode]!['height']!;
  String get weight => _localizedValues[locale.languageCode]!['weight']!;
  String get age => _localizedValues[locale.languageCode]!['age']!;
  String get gender => _localizedValues[locale.languageCode]!['gender']!;
  String get male => _localizedValues[locale.languageCode]!['male']!;
  String get female => _localizedValues[locale.languageCode]!['female']!;
  String get fitnessLevel => _localizedValues[locale.languageCode]!['fitness_level']!;
  String get beginner => _localizedValues[locale.languageCode]!['beginner']!;
  String get intermediate => _localizedValues[locale.languageCode]!['intermediate']!;
  String get advanced => _localizedValues[locale.languageCode]!['advanced']!;
  String get fitnessGoal => _localizedValues[locale.languageCode]!['fitness_goal']!;
  String get weightLoss => _localizedValues[locale.languageCode]!['weight_loss']!;
  String get muscleGain => _localizedValues[locale.languageCode]!['muscle_gain']!;
  String get generalFitness => _localizedValues[locale.languageCode]!['general_fitness']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get updateProfile => _localizedValues[locale.languageCode]!['update_profile']!;
  String get darkMode => _localizedValues[locale.languageCode]!['dark_mode']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  
  // Messages
  String get loginSuccess => _localizedValues[locale.languageCode]!['login_success']!;
  String get loginFailed => _localizedValues[locale.languageCode]!['login_failed']!;
  String get signupSuccess => _localizedValues[locale.languageCode]!['signup_success']!;
  String get signupFailed => _localizedValues[locale.languageCode]!['signup_failed']!;
  String get passwordResetSent => _localizedValues[locale.languageCode]!['password_reset_sent']!;
  String get fillAllFields => _localizedValues[locale.languageCode]!['fill_all_fields']!;
  String get passwordsDontMatch => _localizedValues[locale.languageCode]!['passwords_dont_match']!;
  String get networkError => _localizedValues[locale.languageCode]!['network_error']!;
  
  // Helper method to get any string by key
  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 