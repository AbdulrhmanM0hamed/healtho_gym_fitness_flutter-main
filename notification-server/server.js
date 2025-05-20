const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const axios = require('axios');
const dotenv = require('dotenv');

// Cargar variables de entorno
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.json());
app.use(cors());

// Variables de OneSignal
const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID || '897f8d3f-91cb-4fd1-b5f9-570e9c73cfe6';
const ONESIGNAL_REST_API_KEY = process.env.ONESIGNAL_REST_API_KEY;

app.get('/', (req, res) => {
  res.send('Servidor de notificaciones funcionando correctamente');
});

// Ruta para enviar notificación a todos los usuarios
app.post('/send-notification', async (req, res) => {
  try {
    const { title, message, data } = req.body;
    
    if (!title || !message) {
      return res.status(400).json({
        success: false,
        message: 'Se requieren título y mensaje'
      });
    }
    
    if (!ONESIGNAL_REST_API_KEY) {
      return res.status(500).json({
        success: false,
        message: 'Falta la clave REST API de OneSignal en el servidor'
      });
    }
    
    // Configuración de OneSignal
    const response = await axios.post(
      'https://onesignal.com/api/v1/notifications',
      {
        app_id: ONESIGNAL_APP_ID,
        included_segments: ['All'],
        headings: { en: title, ar: title },
        contents: { en: message, ar: message },
        data: data || {},
        // Usar sonido predeterminado del dispositivo
        // Se han eliminado los sonidos personalizados
        // Asegurar prioridad alta
        priority: 10,
        // Configuración adicional para asegurar entrega
        ttl: 86400,
        collapse_id: 'health_tips',
        mutable_content: true
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${ONESIGNAL_REST_API_KEY}`
        }
      }
    );
    
    console.log('Notificación enviada:', response.data);
    
    return res.status(200).json({
      success: true,
      message: 'Notificación enviada con éxito',
      data: response.data
    });
  } catch (error) {
    console.error('Error al enviar notificación:', error.response?.data || error.message);
    
    return res.status(500).json({
      success: false,
      message: 'Error al enviar la notificación',
      error: error.response?.data || error.message
    });
  }
});

// Ruta para enviar notificación a usuarios específicos por ID
app.post('/send-notification-to-users', async (req, res) => {
  try {
    const { title, message, userIds, data } = req.body;
    
    if (!title || !message || !userIds || !Array.isArray(userIds)) {
      return res.status(400).json({
        success: false,
        message: 'Se requieren título, mensaje y un array de IDs de usuarios'
      });
    }
    
    if (!ONESIGNAL_REST_API_KEY) {
      return res.status(500).json({
        success: false,
        message: 'Falta la clave REST API de OneSignal en el servidor'
      });
    }
    
    // Configuración de OneSignal para usuarios específicos
    const response = await axios.post(
      'https://onesignal.com/api/v1/notifications',
      {
        app_id: ONESIGNAL_APP_ID,
        include_external_user_ids: userIds,
        headings: { en: title, ar: title },
        contents: { en: message, ar: message },
        data: data || {},
        // Usar sonido predeterminado del dispositivo
        // Se han eliminado los sonidos personalizados
        // Asegurar prioridad alta
        priority: 10,
        // Configuración adicional para asegurar entrega
        ttl: 86400,
        collapse_id: 'health_tips',
        mutable_content: true
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${ONESIGNAL_REST_API_KEY}`
        }
      }
    );
    
    console.log('Notificación enviada a usuarios específicos:', response.data);
    
    return res.status(200).json({
      success: true,
      message: 'Notificación enviada con éxito a usuarios específicos',
      data: response.data
    });
  } catch (error) {
    console.error('Error al enviar notificación a usuarios específicos:', error.response?.data || error.message);
    
    return res.status(500).json({
      success: false,
      message: 'Error al enviar la notificación a usuarios específicos',
      error: error.response?.data || error.message
    });
  }
});

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor de notificaciones funcionando en puerto ${PORT}`);
}); 