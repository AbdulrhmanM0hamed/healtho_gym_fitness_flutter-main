import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../dashboard/features/health_tip/data/models/health_tip_model.dart';
import 'package:http/http.dart' as http;

class OneSignalNotificationService {
  static final OneSignalNotificationService _instance = 
      OneSignalNotificationService._internal();
  final Logger _logger = Logger();
  
  // ضع هنا معرف تطبيق OneSignal الخاص بك
  final String _oneSignalAppId = '897f8d3f-91cb-4fd1-b5f9-570e9c73cfe6';
  
  // إعداد الإشعارات المحلية
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // حالة وجود عمود onesignal_id في قاعدة البيانات
  bool _hasOneSignalIdColumn = false;
  
  // URL الخاص بخادم الإشعارات المنشور
  // تحتاج لتغيير هذا الرابط إلى رابط الخادم المنشور الخاص بك
  final String _notificationServerUrl = 'https://notification-server-production-befa.up.railway.app';
  
  factory OneSignalNotificationService() {
    return _instance;
  }

  OneSignalNotificationService._internal() {
    _initServices();
  }
  
  // تهيئة الخدمات
  Future<void> _initServices() async {
    try {
      _logger.i('بدء تهيئة خدمات الإشعارات...');
      
      // تهيئة OneSignal
      await _initOneSignal();
      
      // تهيئة الإشعارات المحلية
      await _initLocalNotifications();
      
      _logger.i('✅ تم تهيئة خدمات الإشعارات بنجاح');
    } catch (e) {
      _logger.e('❌ خطأ في تهيئة خدمات الإشعارات: $e', error: e);
    }
  }
  
  // تهيئة خدمة OneSignal
  Future<void> _initOneSignal() async {
    try {
      _logger.i('تهيئة OneSignal...');
      
      // إعداد مستوى التسجيل للتصحيح
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      
      // تهيئة OneSignal بمعرف التطبيق
      OneSignal.initialize(_oneSignalAppId);
      
      // طلب إذن الإشعارات - استخدم try/catch للتعامل مع الخطأ
      try {
        _logger.i('جاري طلب أذونات الإشعارات...');
        await OneSignal.Notifications.requestPermission(true);
        _logger.i('تم طلب أذونات الإشعارات بنجاح');
      } catch (permissionError) {
        _logger.w('⚠️ خطأ في طلب أذونات الإشعارات: $permissionError');
        _logger.w('⚠️ قد تحتاج إلى إضافة Activity الخاصة بأذونات OneSignal في AndroidManifest.xml');
        // استمر رغم الخطأ
      }
      
      // الاستماع للنقر على الإشعارات
      try {
        OneSignal.Notifications.addClickListener((event) {
          _logger.i('تم النقر على إشعار OneSignal: ${event.notification.additionalData}');
        });
      } catch (listenerError) {
        _logger.w('⚠️ خطأ في إضافة مستمع النقر على الإشعارات: $listenerError');
      }
      
      // التحقق من وجود العمود في قاعدة البيانات
      try {
        await _checkOneSignalIdColumn();
      } catch (checkError) {
        _logger.w('⚠️ خطأ في التحقق من عمود OneSignal: $checkError');
      }
      
      // نتجاهل تحديث قاعدة البيانات لتفادي الأخطاء
      _logger.i('تم تجاهل تحديث قاعدة البيانات بمعرف OneSignal لعدم وجود العمود المطلوب');
      
      _logger.i('✅ تم تهيئة OneSignal بنجاح');
    } catch (e) {
      _logger.e('❌ خطأ في تهيئة OneSignal: $e', error: e);
    }
  }
  
  // التحقق من وجود عمود onesignal_id
  Future<void> _checkOneSignalIdColumn() async {
    try {
      _logger.i('التحقق من وجود عمود onesignal_id...');
      
      // افتراض أن العمود غير موجود بشكل افتراضي
      _hasOneSignalIdColumn = false;
      _logger.i('تم تعيين حالة العمود كغير موجود لتجنب أخطاء قاعدة البيانات');
      
      // تخطي استدعاءات قاعدة البيانات الإضافية
      return;
    } catch (e) {
      _logger.w('⚠️ خطأ في التحقق من عمود onesignal_id: $e');
      _hasOneSignalIdColumn = false;
    }
  }
  
  // تهيئة الإشعارات المحلية
  Future<void> _initLocalNotifications() async {
    try {
      _logger.i('تهيئة الإشعارات المحلية...');
      
      // إعداد قناة الإشعارات لنظام Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      final iosSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        defaultPresentSound: true,
        notificationCategories: [
          DarwinNotificationCategory(
            'health_tips_category',
            actions: [
              DarwinNotificationAction.plain('view', 'View', options: {DarwinNotificationActionOption.foreground}),
            ],
            options: {
              DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
            },
          )
        ]
      );
      
      // إعدادات التهيئة
      final initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      // إعداد معالج النقر على الإشعارات
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          _logger.i('تم النقر على إشعار محلي: ${details.payload}');
        },
      );
      
      // إنشاء قناة الإشعارات عالية الأهمية
  const   androidChannel =   AndroidNotificationChannel(
        'health_tips_channel',
        'Health Tips',
        description: 'Notifications for new health tips',
        importance: Importance.max, // تغيير من high إلى max
        playSound: true,
        enableVibration: true,
        enableLights: true,
        showBadge: true,
        // استخدام الصوت الافتراضي للنظام
        sound: null, // تم تعيينه كـ null لاستخدام الصوت الافتراضي
      );
      
      await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
      
      _logger.i('✅ تم تهيئة الإشعارات المحلية بنجاح');
    } catch (e) {
      _logger.e('❌ خطأ في تهيئة الإشعارات المحلية: $e', error: e);
    }
  }
  
  // حفظ معرف OneSignal في Supabase
  Future<void> _saveOneSignalIdToSupabase() async {
    try {
      // إذا كان العمود غير موجود، تخطي حفظ المعرف
      if (!_hasOneSignalIdColumn) {
        _logger.i('تخطي حفظ معرف OneSignal لأن العمود غير موجود في قاعدة البيانات');
        return;
      }
      
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // إضافة تأخير صغير لمنح OneSignal وقت للتسجيل
        await Future.delayed(const Duration(seconds: 2));
        
        final pushSubscription = OneSignal.User.pushSubscription;
        var oneSignalId = pushSubscription.id;
        
        // محاولة الحصول على المعرف عدة مرات إذا لم يكن متاحًا في البداية
        int retryCount = 0;
        while ((oneSignalId == null || oneSignalId.isEmpty) && retryCount < 3) {
          _logger.w('⚠️ جاري محاولة الحصول على معرف OneSignal (محاولة ${retryCount + 1})...');
          await Future.delayed(const Duration(seconds: 2));
          oneSignalId = OneSignal.User.pushSubscription.id;
          retryCount++;
        }
        
        if (oneSignalId != null && oneSignalId.isNotEmpty) {
          _logger.i('تم الحصول على معرف OneSignal: $oneSignalId للمستخدم: ${user.id}');
          
          // التحقق من وجود سجل المستخدم
          final profile = await Supabase.instance.client
              .from('user_profiles')
              .select()
              .eq('user_id', user.id)
              .maybeSingle();
          
          if (profile != null) {
            // تحديث المعرف في الملف الشخصي
            await Supabase.instance.client
                .from('user_profiles')
                .update({'onesignal_id': oneSignalId})
                .eq('id', profile['id']);
                
            _logger.i('✅ تم تحديث معرف OneSignal بنجاح');
          } else {
            _logger.w('⚠️ لم يتم العثور على ملف المستخدم');
          }
        } else {
          _logger.w('⚠️ لم يتم الحصول على معرف OneSignal بعد ${retryCount} محاولات');
          // سنقوم بتسجيل المعرف لاحقًا من خلال دالة refreshAndSaveId
        }
      }
    } catch (e) {
      _logger.e('❌ خطأ في تحديث معرف OneSignal: $e', error: e);
    }
  }
  
  // إضافة وسم للمستخدم
  Future<void> addTag(String key, String value) async {
    try {
      OneSignal.User.addTagWithKey(key, value);
      _logger.i('تم إضافة الوسم: $key=$value');
    } catch (e) {
      _logger.e('خطأ في إضافة الوسم: $e', error: e);
    }
  }
  
  // إرسال إشعار نصيحة صحية جديدة
  Future<bool> sendNewHealthTipNotification(HealthTipModel healthTip) async {
    try {
      _logger.i('إرسال إشعار لنصيحة صحية جديدة: ${healthTip.title}');
      
      // عرض إشعار محلي فقط
      await _showLocalNotification(healthTip);
      _logger.i('✅ تم إرسال إشعار محلي بنجاح');
      
      return true;
    } catch (e) {
      _logger.e('❌ خطأ في إرسال الإشعار: $e', error: e);
      return false;
    }
  }
  
  // عرض إشعار محلي
  Future<void> _showLocalNotification(HealthTipModel tip) async {
    try {
      _logger.i('عرض إشعار محلي: ${tip.title}');
      
      // تعزيز إعدادات الإشعارات المحلية
      const androidDetails = AndroidNotificationDetails(
        'health_tips_channel',
        'Health Tips',
        channelDescription: 'Notifications for new health tips',
        importance: Importance.max, 
        priority: Priority.max, 
        playSound: true,
        enableVibration: true,
        enableLights: true,
        colorized: true,
        color: Color(0xFF03A9F4), // لون الإشعار
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        category: AndroidNotificationCategory.message,
        visibility: NotificationVisibility.public,
        // استخدام الصوت الافتراضي للنظام
        sound: null, // تم تعيينه كـ null لاستخدام الصوت الافتراضي
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // استخدام الصوت الافتراضي للنظام
        sound: null, // تم تعيينه كـ null لاستخدام الصوت الافتراضي
        badgeNumber: 1,
        interruptionLevel: InterruptionLevel.active,
        categoryIdentifier: 'health_tips_category',
      );
      
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _localNotifications.show(
        tip.id.hashCode,
        tip.title,
        tip.subtitle,
        notificationDetails,
        payload: jsonEncode({'id': tip.id}),
      );
      
      _logger.i('✅ تم عرض الإشعار المحلي بنجاح');
    } catch (e) {
      _logger.e('❌ خطأ في عرض الإشعار المحلي: $e', error: e);
    }
  }
  
  // اختبار إرسال إشعار
  Future<void> testNotification(String title, String body) async {
    try {
      _logger.i('▶️ اختبار إرسال إشعار محلي...');
      
      // جلب معلومات حالة الاشتراك
      final pushSubscription = OneSignal.User.pushSubscription;
      final oneSignalId = pushSubscription.id;
      final isOptedIn = pushSubscription.optedIn;
      
      _logger.i('ℹ️ معرف OneSignal: ${oneSignalId ?? 'غير متوفر بعد'}');
      _logger.i('ℹ️ حالة الاشتراك: $isOptedIn');
      
      // إنشاء نموذج للاختبار
      final testTip = HealthTipModel(
        id: 'test-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        subtitle: body,
        content: 'هذا اختبار للإشعارات',
        imageUrl: null,
        createdAt: DateTime.now(),
        tags: ['اختبار'],
        isFeatured: false,
      );
      
      // عرض إشعار محلي
      await _showLocalNotification(testTip);
      _logger.i('✅ تم إرسال إشعار محلي بنجاح');
      
      // إرسال إشعار لجميع الأجهزة
      await _sendTestPushNotification(title, body);
      
      // محاولة إرسال إشعار عبر الخادم أيضًا
      try {
        final success = await sendNotificationViaServer(title, body);
        if (success) {
          _logger.i('✅ تم إرسال الإشعار عبر الخادم بنجاح');
        } else {
          _logger.w('⚠️ فشل إرسال الإشعار عبر الخادم');
        }
      } catch (serverError) {
        _logger.e('❌ خطأ في إرسال الإشعار عبر الخادم: $serverError');
      }
      
    } catch (e) {
      _logger.e('❌ خطأ في اختبار الإشعار: $e', error: e);
    }
  }
  
  // عرض تعليمات حول كيفية إرسال إشعارات للأجهزة الأخرى
  void _showNotificationInstructions() {
    _logger.i('📱 لإرسال إشعارات للأجهزة الأخرى، يجب اتباع الخطوات التالية:');
    _logger.i('1️⃣ تسجيل الدخول إلى لوحة تحكم OneSignal: https://app.onesignal.com');
    _logger.i('2️⃣ اختيار تطبيقك "Healtho Gym"');
    _logger.i('3️⃣ الانتقال إلى قسم "Audience" ثم "Segments" وإنشاء شريحة جديدة');
    _logger.i('4️⃣ استخدام الشرط: وسم "test_group" يساوي "all_users"');
    _logger.i('5️⃣ الانتقال إلى قسم "Messages" ثم "New Push" واختيار شريحة "test_group=all_users"');
    _logger.i('6️⃣ إدخال عنوان ومحتوى الإشعار ثم الضغط على "Send Message"');
    _logger.i('📝 ملاحظة: لإرسال إشعارات برمجياً من التطبيق إلى جميع الأجهزة، يلزم إنشاء خادم (Backend) مع مفتاح REST API');
  }
  
  // إرسال إشعار اختباري للأجهزة الأخرى
  Future<void> _sendTestPushNotification(String title, String body) async {
    try {
      _logger.i('▶️ إرسال إشعار تجريبي لجميع الأجهزة...');
      
      // تحقق من حالة تسجيل المستخدم
      final pushSubscription = OneSignal.User.pushSubscription;
      if (pushSubscription.id == null || pushSubscription.id!.isEmpty) {
        _logger.w('⚠️ معرف OneSignal غير متوفر، لن يتم إرسال الإشعار');
        return;
      }
      
      _logger.i('معرف المستخدم الحالي: ${pushSubscription.id}');
      _logger.i('محاولة إرسال إشعار إلى جميع المشتركين...');
      
      try {
        // إضافة وسم يمكن استخدامه للاستهداف في لوحة OneSignal
        await OneSignal.User.addTagWithKey('test_group', 'all_users');
        _logger.i('✅ تم إضافة وسم test_group للمستخدم');
        
        // وسوم أخرى مفيدة للتتبع
        await OneSignal.User.addTagWithKey('device_id', pushSubscription.id ?? '');
        await OneSignal.User.addTagWithKey('last_test', DateTime.now().toString());
        await OneSignal.User.addTagWithKey('notification_enabled', 'true');
        
        _logger.i('لإرسال إشعار للجميع، يرجى استخدام لوحة تحكم OneSignal واستهداف المستخدمين ذوي الوسم test_group=all_users');
        _logger.i('يمكن استهداف هذا الجهاز فقط عبر device_id=${pushSubscription.id ?? "unknown"}');
        
      } catch (taggingError) {
        _logger.e('❌ خطأ في إضافة الوسوم: $taggingError', error: taggingError);
        
        // معلومات إضافية للتصحيح
        _logger.i('معلومات عن حالة OneSignal:');
        _logger.i('- معرف الجهاز: ${pushSubscription.id ?? "غير متوفر"}');
        _logger.i('- حالة الاشتراك: ${pushSubscription.optedIn}');
        
        try {
          // محاولة جلب الوسوم الحالية
          final tags = await OneSignal.User.getTags();
          _logger.i('- الوسوم الحالية: $tags');
        } catch (e) {
          _logger.w('⚠️ تعذر جلب الوسوم: $e');
        }
      }
    } catch (e) {
      _logger.e('❌ خطأ عام في إرسال إشعار تجريبي: $e', error: e);
    }
  }
  
  // تحديث معرف OneSignal
  Future<void> refreshAndSaveId() async {
    try {
      _logger.i('جاري تحديث معرف OneSignal...');
      
      // التحقق من وجود العمود أولاً
      await _checkOneSignalIdColumn();
      
      // إذا كان العمود غير موجود، تخطي حفظ المعرف
      if (!_hasOneSignalIdColumn) {
        _logger.i('تخطي حفظ معرف OneSignal لأن العمود غير موجود في قاعدة البيانات');
        return;
      }
      
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // محاولة الحصول على المعرف عدة مرات
        int retryCount = 0;
        String? oneSignalId;
        
        while ((oneSignalId == null || oneSignalId.isEmpty) && retryCount < 5) {
          await Future.delayed(const Duration(seconds: 1));
          oneSignalId = OneSignal.User.pushSubscription.id;
          
          if (oneSignalId == null || oneSignalId.isEmpty) {
            _logger.w('⚠️ محاولة ${retryCount + 1}: لم يتم الحصول على المعرف بعد...');
            retryCount++;
          }
        }
        
        if (oneSignalId != null && oneSignalId.isNotEmpty) {
          _logger.i('تم الحصول على معرف OneSignal: $oneSignalId');
          
          // التحقق من وجود سجل المستخدم
          final profile = await Supabase.instance.client
              .from('user_profiles')
              .select()
              .eq('user_id', user.id)
              .maybeSingle();
          
          if (profile != null) {
            // تحديث المعرف في الملف الشخصي
            await Supabase.instance.client
                .from('user_profiles')
                .update({'onesignal_id': oneSignalId})
                .eq('id', profile['id']);
                
            _logger.i('✅ تم تحديث معرف OneSignal بنجاح');
          } else {
            _logger.w('⚠️ لم يتم العثور على ملف المستخدم');
          }
          return;
        } else {
          _logger.e('❌ فشل الحصول على معرف OneSignal بعد عدة محاولات');
        }
      } else {
        _logger.w('⚠️ المستخدم غير مسجل دخول');
      }
    } catch (e) {
      _logger.e('❌ خطأ في تحديث معرف OneSignal: $e', error: e);
    }
  }
  
  // إرسال إشعار عبر الخادم لجميع الأجهزة
  Future<bool> sendNotificationViaServer(String title, String body) async {
    try {
      _logger.i('▶️ محاولة إرسال إشعار لجميع الأجهزة عبر الخادم...');
      
      final client = http.Client();
      try {
        // استخدام مهلة أطول (10 ثوانٍ)
        final response = await client.post(
          Uri.parse('$_notificationServerUrl/send-notification'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': title,
            'message': body,
            'data': {
              'type': 'test',
              'timestamp': DateTime.now().toString(),
              'app': 'Healtho Gym',
              'highPriority': true
            }
          }),
        ).timeout(const Duration(seconds: 10));
        
        _logger.i('استجابة الخادم: ${response.statusCode} - ${response.body}');
        
        if (response.statusCode == 200) {
          _logger.i('✅ تم إرسال الإشعار بنجاح إلى الخادم');
          return true;
        } else {
          _logger.e('❌ فشل إرسال الإشعار: ${response.body}');
          return false;
        }
      } finally {
        client.close();
      }
    } catch (e) {
      _logger.e('❌ خطأ في إرسال الإشعار عبر الخادم: $e', error: e);
      return false;
    }
  }
  
  // إرسال إشعار لمستخدمين محددين
  Future<bool> sendNotificationToUsers(String title, String body, List<String> userIds) async {
    try {
      _logger.i('▶️ محاولة إرسال إشعار لمستخدمين محددين عبر الخادم...');
      
      final client = http.Client();
      try {
        // استخدام مهلة أطول (10 ثوانٍ)
        final response = await client.post(
          Uri.parse('$_notificationServerUrl/send-notification-to-users'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': title,
            'message': body,
            'userIds': userIds,
            'data': {
              'type': 'target',
              'timestamp': DateTime.now().toString(),
              'app': 'Healtho Gym',
              'highPriority': true
            }
          }),
        ).timeout(const Duration(seconds: 10));
        
        _logger.i('استجابة الخادم: ${response.statusCode} - ${response.body}');
        
        if (response.statusCode == 200) {
          _logger.i('✅ تم إرسال الإشعار بنجاح للمستخدمين المحددين');
          return true;
        } else {
          _logger.e('❌ فشل إرسال الإشعار للمستخدمين المحددين: ${response.body}');
          return false;
        }
      } finally {
        client.close();
      }
    } catch (e) {
      _logger.e('❌ خطأ في إرسال الإشعار للمستخدمين المحددين: $e', error: e);
      return false;
    }
  }
} 