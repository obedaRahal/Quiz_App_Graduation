import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/services/notification/fcm_token.dart';
import 'package:quiz_app_grad/core/services/notification/local_votification_service.dart';
import 'package:quiz_app_grad/core/utils/app_logger.dart';
import 'package:quiz_app_grad/firebase_options.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future<void>? _initializationFuture;
  static StreamSubscription<String>? _tokenRefreshSubscription;

  static Future<void> init() {
    return _initializationFuture ??= _init();
  }

  static Future<void> _init() async {
    final settings = await messaging.requestPermission();
    debugPrint('🔐 FCM permission: ${settings.authorizationStatus}');

    final token = await getTokenForLogin();
    debugPrint('📲 initial FCM registration available: ${token != null}');

    _listenForTokenRefresh();
    _handleForegroundMessages();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📬 onMessageOpenedApp: ${message.messageId}');
      debugPrint('📬 notification data received: ${message.data.isNotEmpty}');
      // Android/iOS already resumes the app. External notification taps must
      // not force navigation to the in-app notifications screen.
    });
  }

  static Future<String?> getTokenForLogin() async {
    final cachedToken = _nonEmptyToken(FcmTokenStorage.getToken());
    if (cachedToken != null) {
      debugPrint('✓ using cached FCM token for login');
      return cachedToken;
    }

    debugPrint('⚠ cached FCM token is empty; requesting one from Firebase');

    for (var attempt = 1; attempt <= 2; attempt++) {
      try {
        final token = _nonEmptyToken(await messaging.getToken());

        if (token != null) {
          await FcmTokenStorage.saveToken(token);
          debugPrint('✓ FCM token fetched for login (attempt: $attempt)');
          return token;
        }

        debugPrint(
          '⚠ Firebase returned an empty FCM token (attempt: $attempt)',
        );
      } catch (error, stackTrace) {
        debugPrint(
          '✗ failed to fetch FCM token for login '
          '(attempt: $attempt): $error',
        );
        debugPrintStack(stackTrace: stackTrace);
      }

      if (attempt == 1) {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }
    }

    debugPrint('✗ FCM token is still unavailable after retry');
    return null;
  }

  static void _listenForTokenRefresh() {
    _tokenRefreshSubscription ??= messaging.onTokenRefresh.listen(
      (token) async {
        final normalizedToken = _nonEmptyToken(token);
        if (normalizedToken == null) return;

        await FcmTokenStorage.saveToken(normalizedToken);
        debugPrint('✓ refreshed FCM token cached');
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('✗ FCM token refresh listener failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      },
    );
  }

  static void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('🚀 ENTERED onMessage (foreground)');
      debugPrint('📩 messageId: ${message.messageId}');
      debugPrint('📩 notification payload received');

      try {
        await LocalNotificationService.showBasicNotification(
          message,
          openNotificationsOnTap: true,
        );
      } catch (error, stackTrace) {
        debugPrint('✗ foreground notification could not be displayed');
        debugPrintStack(stackTrace: stackTrace);
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.configure();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FCM/APNs displays notification payloads automatically in the background.
  // Only data-only messages need us to create a local notification.
  if (message.notification == null) {
    await LocalNotificationService.init();
    await LocalNotificationService.showBasicNotification(
      message,
      openNotificationsOnTap: false,
    );
  }

  debugPrint(
    '📩 Background message: ${message.messageId}, '
    'systemDisplayed: ${message.notification != null}',
  );
  debugPrint('📩 Background data received: ${message.data.isNotEmpty}');
}

String? _nonEmptyToken(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
