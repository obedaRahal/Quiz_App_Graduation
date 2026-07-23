import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController.broadcast();

  static Future<void>? _initializationFuture;

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

  static Future<void> init() {
    return _initializationFuture ??= _init();
  }

  static Future<void> _init() async {
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

    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(android: android, iOS: ios);
    final title =
        _textValue(message.notification?.title) ??
        _textValue(message.data['title']) ??
        'إشعار جديد';
    final body =
        _textValue(message.notification?.body) ??
        _textValue(message.data['body']) ??
        _textValue(message.data['message']) ??
        '';

    debugPrint("🔔 SHOWING LOCAL NOTIFICATION");

    await flutterLocalNotificationsPlugin.show(
      id: _notificationId(message),
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode({
        'message_id': message.messageId,
        'data': message.data,
      }),
    );

    debugPrint("✅ LOCAL NOTIFICATION SHOWN");
  }
}

String? _textValue(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  return text.isEmpty || text.toLowerCase() == 'null' ? null : text;
}

int _notificationId(RemoteMessage message) {
  final identity = _notificationIdentity(message);

  if (identity == null) {
    return DateTime.now().millisecondsSinceEpoch.remainder(0x7fffffff);
  }

  var hash = 0;
  for (final codeUnit in identity.codeUnits) {
    hash = ((hash * 31) + codeUnit) & 0x7fffffff;
  }

  return hash == 0 ? 1 : hash;
}

String? _notificationIdentity(RemoteMessage message) {
  for (final value in [
    message.data['notification_key'],
    message.data['notification_id'],
    message.data['id'],
    message.messageId,
  ]) {
    final identity = _textValue(value);
    if (identity != null) return identity;
  }

  return null;
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  LocalNotificationService.streamController.add(notificationResponse);
}
