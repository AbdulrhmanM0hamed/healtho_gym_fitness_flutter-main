import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healtho_gym/common/color_extension.dart';

enum ToastType {
  success,
  error,
  info,
  warning,
}

class ToastHelper {
  static final ToastHelper _instance = ToastHelper._internal();
  
  factory ToastHelper() => _instance;
  
  ToastHelper._internal();
  
  // Simple toast notification
  static Future<void> showToast({
    required String message,
    ToastType type = ToastType.info,
    Toast length = Toast.LENGTH_SHORT,
  }) async {
    Color backgroundColor;
    
    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        break;
      case ToastType.error:
        backgroundColor = Colors.red;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        break;
      case ToastType.info:
      default:
        backgroundColor = TColor.primary;
        break;
    }
    
    await Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,

    );
  }
  
  // Advanced snackbar with rich styling
  static void showFlushbar({
    required BuildContext context,
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    Widget? button,
    VoidCallback? onDismissed,
  }) {
    Color backgroundColor;
    Color borderColor;
    IconData icon;
    
    switch (type) {
      case ToastType.success:
        backgroundColor = const Color(0xFF2ecc71);
        borderColor = const Color(0xFF27ae60);
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = const Color(0xFFe74c3c);
        borderColor = const Color(0xFFc0392b);
        icon = Icons.error;
        break;
      case ToastType.warning:
        backgroundColor = const Color(0xFFf39c12);
        borderColor = const Color(0xFFe67e22);
        icon = Icons.warning;
        break;
      case ToastType.info:
      default:
        backgroundColor = TColor.primary;
        borderColor = TColor.primary.withOpacity(0.8);
        icon = Icons.info;
        break;
    }
    
    Flushbar(
      title: title,
      message: message,
      icon: Icon(
        icon,
        size: 28.0,
        color: Colors.white,
      ),
      duration: duration,
      borderColor: borderColor,
      borderWidth: 2,
      backgroundColor: backgroundColor,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          offset: const Offset(0, 2),
          blurRadius: 10,
        )
      ],
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: isDismissible,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      mainButton: button,
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED && onDismissed != null) {
          onDismissed();
        }
      },
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(20),
    ).show(context);
  }
  
  // Show snackbar specifically for auth errors
  static void showAuthError({
    required BuildContext context,
    required String message,
    VoidCallback? onRetry,
  }) {
    showFlushbar(
      context: context,
      title: 'خطأ في تسجيل الدخول',
      message: message,
      type: ToastType.error,
      duration: const Duration(seconds: 5),
      button: onRetry != null
          ? TextButton(
              onPressed: onRetry,
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
  
  // Show snackbar for successful operations
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    showFlushbar(
      context: context,
      title: title ?? 'تم بنجاح',
      message: message,
      type: ToastType.success,
    );
  }
  
  // Show network error snackbar
  static void showNetworkError({
    required BuildContext context,
    VoidCallback? onRetry,
  }) {
    showFlushbar(
      context: context,
      title: 'خطأ في الاتصال',
      message: 'حدث خطأ في الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.',
      type: ToastType.warning,
      button: onRetry != null
          ? TextButton(
              onPressed: onRetry,
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
} 