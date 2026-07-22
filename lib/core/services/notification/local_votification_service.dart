import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController.broadcast();

  static void onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'quiz_high_importance_channel',
    'Quiz Notifications',
    description: 'Quiz app notifications',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  static Future<void> showBasicNotification(RemoteMessage message) async {
    final android = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'New Notification',
    );

    final details = NotificationDetails(android: android);

    debugPrint("🔔 SHOWING LOCAL NOTIFICATION");

    await flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? 'إشعار جديد',
      body: message.notification?.body ?? '',
      notificationDetails: details,
    );

    debugPrint("✅ LOCAL NOTIFICATION SHOWN");
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  LocalNotificationService.streamController.add(notificationResponse);
}
