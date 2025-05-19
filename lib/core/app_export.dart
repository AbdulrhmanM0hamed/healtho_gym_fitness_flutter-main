/* 
تعليمات تفعيل إشعارات النصائح الصحية:

1. تأكد من إضافة التبعيات المطلوبة في pubspec.yaml:
   - firebase_core
   - firebase_messaging
   - flutter_local_notifications

2. تأكد من إضافة ملف google-services.json في مجلد android/app

3. عند تسجيل دخول المستخدم، سيتم تلقائياً:
   - طلب صلاحيات الإشعارات
   - تحديث FCM token وحفظه في جدول user_profiles

4. عند إضافة نصيحة صحية جديدة، سيتم تلقائياً:
   - إرسال إشعار لجميع المستخدمين المسجلين
   - الإشعارات تعمل عن طريق Firebase Cloud Messaging مباشرة

ملاحظات إضافية:
- يتم استخدام مفتاح Server Key المخزن في HealthTipNotificationService
- تأكد من صلاحية المفتاح وتحديثه إذا لزم الأمر
*/ 