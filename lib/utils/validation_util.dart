class ValidationUtil {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    
    return null;
  }
  
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid number';
    }
    
    if (age < 12 || age > 100) {
      return 'Age must be between 12 and 100';
    }
    
    return null;
  }
  
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your height';
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid number';
    }
    
    // Height in cm
    if (height < 100 || height > 250) {
      return 'Height must be between 100cm and 250cm';
    }
    
    return null;
  }
  
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your weight';
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    
    // Weight in kg
    if (weight < 30 || weight > 300) {
      return 'Weight must be between 30kg and 300kg';
    }
    
    return null;
  }
} 