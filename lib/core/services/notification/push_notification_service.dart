import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/services/notification/fcm_token.dart';
import 'package:quiz_app_grad/core/services/notification/local_votification_service.dart';
import 'package:quiz_app_grad/firebase_options.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    final settings = await messaging.requestPermission();
    debugPrint('🔐 FCM permission: ${settings.authorizationStatus}');

    final token = await messaging.getToken();
    log("📲 FCM token is : $token");

    await FcmTokenStorage.saveToken(token);

    _handleForegroundMessages();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📬 onMessageOpenedApp: ${message.messageId}');
    });
  }

  static void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🚀 ENTERED onMessage (foreground)');
      debugPrint('📩 title: ${message.notification?.title}');
      debugPrint('📩 body : ${message.notification?.body}');

      LocalNotificationService.showBasicNotification(message);
    });
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalNotificationService.init();

  await LocalNotificationService.showBasicNotification(message);

  debugPrint('📩 Background message: ${message.messageId}');
}
