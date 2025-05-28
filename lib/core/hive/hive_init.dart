import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// تهيئة Hive للتخزين المحلي
class HiveInit {
  /// تهيئة Hive
  static Future<void> init() async {
    // الحصول على مسار التخزين
    final appDocumentDir = await getApplicationDocumentsDirectory();
    
    // تهيئة Hive مع المسار
    await Hive.initFlutter(appDocumentDir.path);
    
    // تسجيل المحولات (adapters) إذا كان هناك حاجة
    // Hive.registerAdapter(CustomExerciseAdapter());
  }
}
