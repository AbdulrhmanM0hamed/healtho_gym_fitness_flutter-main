// OneSignal notification server
const express = require('express');
const cors = require('cors');
const axios = require('axios');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 3000;

// السماح بطلبات CORS من التطبيق
app.use(cors());
app.use(bodyParser.json());

// مفتاح REST API الخاص بـ OneSignal (يجب استبداله بمفتاحك)
// يمكنك الحصول على المفتاح من لوحة تحكم OneSignal: Settings > Keys & IDs
const ONE_SIGNAL_REST_API_KEY = 'os_v2_app_rf7y2p4rznh5dnpzk4hjy46p42gt6cv2hmducd4zpi5koivbdqimhf2cuk6et76rqhamcxhuh4tiiu7bi26fyzwtm2d7dkb26tku4xa';
const ONE_SIGNAL_APP_ID = '897f8d3f-91cb-4fd1-b5f9-570e9c73cfe6';

// الصفحة الرئيسية
app.get('/', (req, res) => {
  res.send('خادم إشعارات Healtho Gym يعمل بنجاح! استخدم /send-notification لإرسال إشعارات');
});

// إرسال إشعار لجميع المستخدمين
app.post('/send-notification', async (req, res) => {
  try {
    const { title, message, data } = req.body;
    
    if (!title || !message) {
      return res.status(400).json({ 
        success: false, 
        error: 'يلزم توفير العنوان والرسالة' 
      });
    }
    
    const response = await axios.post(
      'https://onesignal.com/api/v1/notifications',
      {
        app_id: ONE_SIGNAL_APP_ID,
        headings: { en: title, ar: title },
        contents: { en: message, ar: message },
        data: data || {},
        included_segments: ['All'],  // إرسال للجميع
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${ONE_SIGNAL_REST_API_KEY}`
        }
      }
    );
    
    return res.status(200).json({
      success: true,
      data: response.data
    });
    
  } catch (error) {
    console.error('Error sending notification:', error.response?.data || error.message);
    return res.status(500).json({
      success: false,
      error: error.response?.data || error.message
    });
  }
});

// إرسال إشعار باستخدام وسم (tag)
app.post('/send-notification-by-tag', async (req, res) => {
  try {
    const { title, message, tagKey, tagValue, data } = req.body;
    
    if (!title || !message || !tagKey || !tagValue) {
      return res.status(400).json({ 
        success: false, 
        error: 'يلزم توفير العنوان والرسالة والوسم' 
      });
    }
    
    const response = await axios.post(
      'https://onesignal.com/api/v1/notifications',
      {
        app_id: ONE_SIGNAL_APP_ID,
        headings: { en: title, ar: title },
        contents: { en: message, ar: message },
        data: data || {},
        filters: [
          { field: 'tag', key: tagKey, relation: '=', value: tagValue }
        ]
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${ONE_SIGNAL_REST_API_KEY}`
        }
      }
    );
    
    return res.status(200).json({
      success: true,
      data: response.data
    });
    
  } catch (error) {
    console.error('Error sending notification:', error.response?.data || error.message);
    return res.status(500).json({
      success: false,
      error: error.response?.data || error.message
    });
  }
});

// بدء تشغيل الخادم
app.listen(PORT, () => {
  console.log(`خادم الإشعارات يعمل على المنفذ ${PORT}`);
}); 