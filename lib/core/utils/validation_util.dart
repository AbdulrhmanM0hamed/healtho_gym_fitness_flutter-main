class ValidationUtil {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'الرجاء إدخال عنوان بريد إلكتروني صالح';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    
    if (value.length < 6) {
      return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
    }
    
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'الرجاء تأكيد كلمة المرور';
    }
    
    if (value != password) {
      return 'كلمات المرور غير متطابقة';
    }
    
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الاسم';
    }
    
    return null;
  }
  
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال العمر';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'الرجاء إدخال رقم صحيح';
    }
    
    if (age < 12 || age > 100) {
      return 'يجب أن يكون العمر بين 12 و 100';
    }
    
    return null;
  }
  
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الطول';
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'الرجاء إدخال رقم صحيح';
    }
    
    // Height in cm
    if (height < 100 || height > 250) {
      return 'يجب أن يكون الطول بين 100 و 250 سم';
    }
    
    return null;
  }
  
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الوزن';
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'الرجاء إدخال رقم صحيح';
    }
    
    // Weight in kg
    if (weight < 30 || weight > 300) {
      return 'يجب أن يكون الوزن بين 30 و 300 كجم';
    }
    
    return null;
  }
} 