import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/services/notification/fcm_token.dart';
import 'package:quiz_app_grad/core/services/notification/local_votification_service.dart';
import 'package:quiz_app_grad/firebase_options.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future<void>? _initializationFuture;

  static Future<void> init() {
    return _initializationFuture ??= _init();
  }

  static Future<void> _init() async {
    final settings = await messaging.requestPermission();
    debugPrint('🔐 FCM permission: ${settings.authorizationStatus}');

    final token = await messaging.getToken();
    log("📲 FCM token is : $token");

    await FcmTokenStorage.saveToken(token);

    _handleForegroundMessages();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📬 onMessageOpenedApp: ${message.messageId}');
      debugPrint('📬 data: ${message.data}');
    });
  }

  static void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('🚀 ENTERED onMessage (foreground)');
      debugPrint('📩 messageId: ${message.messageId}');
      debugPrint('📩 title: ${message.notification?.title}');
      debugPrint('📩 body : ${message.notification?.body}');
      debugPrint('📩 data  : ${message.data}');

      await LocalNotificationService.showBasicNotification(message);
    });
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FCM/APNs displays notification payloads automatically in the background.
  // Only data-only messages need us to create a local notification.
  if (message.notification == null) {
    await LocalNotificationService.init();
    await LocalNotificationService.showBasicNotification(message);
  }

  debugPrint(
    '📩 Background message: ${message.messageId}, '
    'systemDisplayed: ${message.notification != null}',
  );
  debugPrint('📩 Background data: ${message.data}');
}
