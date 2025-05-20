# Servidor de Notificaciones para Healtho Gym

Este servidor permite enviar notificaciones push a través de OneSignal a todos los usuarios o a usuarios específicos de la aplicación Healtho Gym.

## Requisitos

- Node.js 18.x o superior
- Cuenta en OneSignal
- Clave REST API de OneSignal

## Configuración

1. Crea un archivo `.env` en la raíz del proyecto basado en `.env.example`:

```
PORT=3000
ONESIGNAL_APP_ID=tu_app_id_de_onesignal
ONESIGNAL_REST_API_KEY=tu_clave_rest_api_de_onesignal
```

2. Instala las dependencias:

```bash
npm install
```

## Ejecución local

```bash
npm run dev
```

El servidor estará disponible en `http://localhost:3000`

## API

### Enviar notificación a todos los usuarios

```
POST /send-notification
```

Cuerpo de la solicitud:
```json
{
  "title": "Título de la notificación",
  "message": "Contenido de la notificación",
  "data": {
    "tipo": "health_tip",
    "id": "123"
  }
}
```

### Enviar notificación a usuarios específicos

```
POST /send-notification-to-users
```

Cuerpo de la solicitud:
```json
{
  "title": "Título de la notificación",
  "message": "Contenido de la notificación",
  "userIds": ["id1", "id2", "id3"],
  "data": {
    "tipo": "health_tip",
    "id": "123"
  }
}
```

## Despliegue en Render (Gratuito)

1. Crea una cuenta en [Render](https://render.com/)
2. Desde el dashboard, haz clic en "New" y selecciona "Web Service"
3. Conecta tu repositorio de GitHub o sube el código
4. Configura el servicio:
   - Nombre: `healtho-notifications` (o el que prefieras)
   - Runtime: `Node`
   - Build Command: `npm install`
   - Start Command: `npm start`
5. En la sección "Environment Variables", agrega:
   - `ONESIGNAL_APP_ID`: Tu App ID de OneSignal
   - `ONESIGNAL_REST_API_KEY`: Tu clave REST API de OneSignal
6. Haz clic en "Create Web Service"

## Despliegue en Railway (Gratuito)

1. Crea una cuenta en [Railway](https://railway.app/)
2. Inicia un nuevo proyecto y selecciona "Deploy from GitHub repo"
3. Conecta tu repositorio
4. En la sección "Variables", agrega:
   - `ONESIGNAL_APP_ID`: Tu App ID de OneSignal
   - `ONESIGNAL_REST_API_KEY`: Tu clave REST API de OneSignal
5. El despliegue comenzará automáticamente

## Actualización de la aplicación Flutter

Una vez desplegado el servidor, actualiza la URL en tu aplicación Flutter:

```dart
// En one_signal_notification_service.dart
// Cambia:
Uri.parse('http://10.0.2.2:3000/send-notification')
// Por la URL de tu servidor desplegado:
Uri.parse('https://tu-servidor-desplegado.onrender.com/send-notification')
``` 