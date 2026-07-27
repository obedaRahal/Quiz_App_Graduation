import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/services/notification/local_votification_service.dart';

void main() {
  group('LocalNotificationService notification tap payload', () {
    test('opens notifications only for a foreground notification', () {
      const payload = '{"message_id":"message-1","open_notifications":true}';

      expect(
        LocalNotificationService.shouldOpenNotificationsFromPayload(payload),
        isTrue,
      );
    });

    test('does not force navigation for an external notification tap', () {
      const payload = '{"message_id":"message-1","open_notifications":false}';

      expect(
        LocalNotificationService.shouldOpenNotificationsFromPayload(payload),
        isFalse,
      );
    });

    test('treats missing or malformed payloads as external taps', () {
      expect(
        LocalNotificationService.shouldOpenNotificationsFromPayload(null),
        isFalse,
      );
      expect(
        LocalNotificationService.shouldOpenNotificationsFromPayload('not-json'),
        isFalse,
      );
    });
  });
}
