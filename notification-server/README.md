# خادم إشعارات Healtho Gym

خادم بسيط لإرسال إشعارات OneSignal لجميع مستخدمي تطبيق Healtho Gym.

## المتطلبات

- Node.js (الإصدار 14 أو أحدث)
- مفتاح REST API من OneSignal

## التثبيت

1. قم بفتح موجه الأوامر أو Terminal في مجلد `notification-server`
2. قم بتثبيت الاعتمادات:

```bash
npm install
```

3. افتح ملف `onesignal-server.js` واستبدل `YOUR_ONESIGNAL_REST_API_KEY` بمفتاح REST API الخاص بك من OneSignal (Settings > Keys & IDs)

## التشغيل

لتشغيل الخادم:

```bash
npm start
```

للتطوير مع إعادة التشغيل التلقائي:

```bash
npm run dev
```

الخادم سيعمل على المنفذ 3000 بشكل افتراضي: http://localhost:3000

## استخدام الخادم

### إرسال إشعار لجميع المستخدمين

قم بإرسال طلب POST إلى `/send-notification`:

```bash
curl -X POST http://localhost:3000/send-notification \
  -H "Content-Type: application/json" \
  -d '{"title": "عنوان الإشعار", "message": "محتوى الإشعار"}'
```

### إرسال إشعار للمستخدمين حسب الوسم

قم بإرسال طلب POST إلى `/send-notification-by-tag`:

```bash
curl -X POST http://localhost:3000/send-notification-by-tag \
  -H "Content-Type: application/json" \
  -d '{"title": "عنوان الإشعار", "message": "محتوى الإشعار", "tagKey": "test_group", "tagValue": "all_users"}'
```

## استخدام الخادم من تطبيق Flutter

يمكنك استدعاء الخادم من تطبيق Flutter باستخدام مكتبة `http`:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendNotificationToAll(String title, String message) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.2:3000/send-notification'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'title': title,
      'message': message,
    }),
  );
  
  if (response.statusCode == 200) {
    print('تم إرسال الإشعار بنجاح');
  } else {
    print('فشل إرسال الإشعار: ${response.body}');
  }
}
```

## الحصول على مفتاح REST API

1. قم بتسجيل الدخول إلى لوحة تحكم OneSignal: https://app.onesignal.com
2. اختر تطبيقك
3. انتقل إلى Settings > Keys & IDs
4. انسخ مفتاح REST API 