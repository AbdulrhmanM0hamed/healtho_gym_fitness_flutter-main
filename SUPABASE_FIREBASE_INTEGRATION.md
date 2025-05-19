# دليل إعداد Supabase Edge Functions مع Firebase Cloud Messaging

## المشكلة السابقة

لا يمكن إرسال إشعارات Firebase مباشرة من تطبيق الجوال إلى الأجهزة الأخرى لأسباب أمنية. 

## الحل باستخدام Supabase Edge Functions

Supabase Edge Functions توفر بديلاً مثالياً لـ Firebase Cloud Functions، مع ميزات:
- لا تحتاج لترقية Firebase إلى خطة مدفوعة
- سهلة التطوير والنشر
- تدعم TypeScript/Deno
- تكامل مباشر مع مشروع Supabase الحالي

## خطوات الإعداد

### 1. الحصول على مفاتيح Firebase Admin

1. انتقل إلى [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك
3. انتقل إلى **Project settings** > **Service accounts**
4. اضغط على **Generate new private key**
5. سيتم تنزيل ملف JSON يحتوي على المفاتيح السرية

### 2. إعداد مشروع Supabase

1. انشئ حساب على [Supabase](https://supabase.io/)
2. أنشئ مشروعاً جديداً أو استخدم مشروعاً موجوداً
3. انتقل إلى **Settings** > **API**
4. احفظ `URL` و `anon key` لاستخدامهما لاحقاً

### 3. تخزين مفاتيح Firebase كـ Secrets في Supabase

1. افتح لوحة تحكم Supabase
2. انتقل إلى **Settings** > **API** > **Secrets**
3. أضف المفاتيح التالية:

```
FIREBASE_PROJECT_ID = قيمة project_id من ملف JSON
FIREBASE_CLIENT_EMAIL = قيمة client_email من ملف JSON
FIREBASE_PRIVATE_KEY = قيمة private_key من ملف JSON (تأكد من استبدال \n بسطر جديد حقيقي)
```

### 4. تثبيت Supabase CLI

```bash
# تثبيت Supabase CLI
npm install -g supabase

# تسجيل الدخول
supabase login

# إعداد المشروع المحلي
mkdir supabase-functions
cd supabase-functions
supabase init
```

### 5. إنشاء Edge Function

1. أنشئ دالة جديدة:

```bash
supabase functions new send-fcm
```

2. افتح الملف `supabase/functions/send-fcm/index.ts` وأضف الكود التالي:

```typescript
// supabase/functions/send-fcm/index.ts
import { serve } from 'https://deno.land/std/http/server.ts'
import { initializeApp, cert } from "https://esm.sh/firebase-admin@11.5.0/app";
import { getMessaging } from "https://esm.sh/firebase-admin@11.5.0/messaging";

serve(async (req) => {
  try {
    // استخراج المعلومات من الطلب
    const { title, body, topic, token, tokens } = await req.json();
    
    console.log(`Processing FCM notification: ${title}`);
    
    // استخراج مفاتيح Firebase من متغيرات البيئة
    const privateKey = Deno.env.get("FIREBASE_PRIVATE_KEY")!.replace(/\\n/g, '\n');
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID");
    const clientEmail = Deno.env.get("FIREBASE_CLIENT_EMAIL");
    
    // التحقق من وجود المفاتيح المطلوبة
    if (!privateKey || !projectId || !clientEmail) {
      console.error("Missing Firebase credentials");
      return new Response(
        JSON.stringify({ error: "Missing Firebase credentials" }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }
    
    // تهيئة تطبيق Firebase Admin
    initializeApp({
      credential: cert({
        projectId,
        clientEmail,
        privateKey,
      }),
    });
    
    // إعداد رسالة الإشعار
    let message: any = {
      notification: {
        title,
        body,
      },
      android: {
        notification: {
          channelId: 'health_tips_channel',
          priority: 'high',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };
    
    let response;
    
    // إرسال الإشعار حسب نوع الهدف (موضوع، جهاز واحد، أو عدة أجهزة)
    if (topic) {
      // إرسال إلى موضوع
      console.log(`Sending to topic: ${topic}`);
      message.topic = topic;
      response = await getMessaging().send(message);
    } else if (token) {
      // إرسال إلى جهاز واحد
      console.log(`Sending to token: ${token.substring(0, 10)}...`);
      message.token = token;
      response = await getMessaging().send(message);
    } else if (tokens && tokens.length > 0) {
      // إرسال إلى عدة أجهزة
      console.log(`Sending to ${tokens.length} devices`);
      message.tokens = tokens;
      response = await getMessaging().sendMulticast(message);
    } else {
      return new Response(
        JSON.stringify({ error: "No target specified (topic, token, or tokens)" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }
    
    console.log("FCM response:", response);
    
    return new Response(
      JSON.stringify({ success: true, messageId: response }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("Error sending FCM:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
```

### 6. نشر Edge Function

```bash
# أضف المفاتيح السرية
supabase secrets set FIREBASE_PROJECT_ID=xxx FIREBASE_CLIENT_EMAIL=xxx FIREBASE_PRIVATE_KEY="xxx"

# نشر الدالة
supabase functions deploy send-fcm --project-ref YOUR_PROJECT_REF
```

### 7. تحديث خدمة الإشعارات في Flutter

أضف الكود التالي إلى تطبيق Flutter:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class HealthTipNotificationService {
  final String _supabaseFunctionUrl = 'https://YOUR_PROJECT_ID.supabase.co/functions/v1/send-fcm';
  final String _supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // إرسال إشعار
  Future<bool> sendNotification(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse(_supabaseFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_supabaseAnonKey',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
          'topic': 'health_tips', // إرسال إلى كل المشتركين
        }),
      );
      
      if (response.statusCode == 200) {
        print('تم إرسال الإشعار بنجاح');
        return true;
      } else {
        print('فشل إرسال الإشعار: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('خطأ: $e');
      return false;
    }
  }
  
  // الاشتراك في موضوع
  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
  
  // إلغاء الاشتراك في موضوع
  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
```

### 8. تحديث استدعاء الإشعارات في الكود

عند إضافة نصيحة صحية جديدة:

```dart
final healthTipService = sl<HealthTipNotificationService>();
await healthTipService.sendNotification(
  'نصيحة صحية جديدة',
  'اشرب كوب ماء كل صباح!',
);
```

## خلاصة

بهذا الترتيب، يمكنك إرسال إشعارات FCM من تطبيقك بدون الحاجة إلى سيرفر خارجي أو ترقية Firebase إلى خطة مدفوعة. Supabase Edge Functions توفر حلاً سهلاً ومرناً لتنفيذ المهام السحابية في تطبيقات الجوال. 