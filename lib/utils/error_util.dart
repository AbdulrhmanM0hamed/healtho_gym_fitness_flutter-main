import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorUtil {
  // Authentication errors
  static String getAuthErrorMessage(dynamic error) {
    if (error is AuthException) {
      return _handleAuthException(error);
    } else if (error is AuthApiException) {
      return _handleAuthApiException(error);
    } else if (error is PostgrestException) {
      return _handlePostgrestException(error);
    } else if (error is StorageException) {
      return _handleStorageException(error);
    } else if (error is SocketException) {
      return 'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك بالشبكة والمحاولة مرة أخرى.';
    } else {
      return 'حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى لاحقاً.';
    }
  }
  
  // Handle specific auth exceptions
  static String _handleAuthException(AuthException error) {
    switch (error.message) {
      case 'User already registered':
        return 'البريد الإلكتروني مسجل بالفعل. يرجى استخدام بريد إلكتروني آخر أو تسجيل الدخول.';
      case 'Email not confirmed':
        return 'لم يتم تأكيد البريد الإلكتروني. يرجى التحقق من بريدك الإلكتروني لتأكيد حسابك.';
      case 'Invalid login credentials':
        return 'بيانات تسجيل الدخول غير صحيحة. يرجى التحقق من البريد الإلكتروني وكلمة المرور.';
      case 'Email link is invalid or has expired':
        return 'رابط البريد الإلكتروني غير صالح أو انتهت صلاحيته. يرجى طلب رابط جديد.';
      default:
        return 'خطأ في المصادقة: ${error.message}';
    }
  }
  
  // Handle API auth exceptions
  static String _handleAuthApiException(AuthApiException error) {
    switch (error.code) {
      case 'invalid_credentials':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى التحقق من بياناتك والمحاولة مرة أخرى.';
      case 'user_not_found':
        return 'لم يتم العثور على المستخدم. يرجى التأكد من البريد الإلكتروني أو التسجيل.';
      case 'email_taken':
        return 'هذا البريد الإلكتروني مستخدم بالفعل. يرجى استخدام بريد إلكتروني آخر.';
      case 'weak_password':
        return 'كلمة المرور ضعيفة جداً. يرجى استخدام كلمة مرور أقوى تحتوي على أحرف وأرقام ورموز.';
      case 'too_many_requests':
        return 'تم إجراء الكثير من الطلبات. يرجى المحاولة مرة أخرى بعد قليل.';
      default:
        return 'خطأ في التحقق: ${error.message}';
    }
  }
  
  // Handle Postgrest exceptions
  static String _handlePostgrestException(PostgrestException error) {
    if (error.message.contains('duplicate key')) {
      return 'هذه البيانات موجودة بالفعل في النظام.';
    } else if (error.message.contains('foreign key constraint')) {
      return 'لا يمكن إكمال العملية بسبب ارتباط البيانات بسجلات أخرى.';
    } else if (error.message.contains('not found')) {
      return 'لم يتم العثور على البيانات المطلوبة.';
    } else {
      return 'حدث خطأ في قاعدة البيانات: ${error.message}';
    }
  }
  
  // Handle Storage exceptions
  static String _handleStorageException(StorageException error) {
    switch (error.statusCode) {
      case 401:
        return 'غير مصرح لك بالوصول إلى هذا الملف.';
      case 403:
        return 'ليس لديك الصلاحيات الكافية للوصول إلى هذا الملف.';
      case 404:
        return 'لم يتم العثور على الملف المطلوب.';
      case 409:
        return 'يوجد تعارض مع الملف الحالي.';
      case 413:
        return 'حجم الملف كبير جداً. يرجى تحميل ملف أصغر.';
      default:
        return 'خطأ في تخزين الملفات: ${error.message}';
    }
  }
  
  // Profile errors
  static String getProfileErrorMessage(dynamic error) {
    if (error is String && error.contains('Profile not found')) {
      return 'لم يتم العثور على الملف الشخصي. يرجى إنشاء ملف شخصي جديد.';
    } else {
      return getAuthErrorMessage(error);
    }
  }
  
  // Network errors
  static String getNetworkErrorMessage() {
    return 'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
  }
  
  // Input validation errors
  static String getValidationErrorMessage(String field) {
    switch (field) {
      case 'email':
        return 'يرجى إدخال بريد إلكتروني صالح.';
      case 'password':
        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل وتحتوي على أحرف وأرقام.';
      case 'name':
        return 'يرجى إدخال الاسم بشكل صحيح.';
      case 'phone':
        return 'يرجى إدخال رقم هاتف صالح.';
      default:
        return 'يرجى التأكد من إدخال بيانات صحيحة.';
    }
  }
} 