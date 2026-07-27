import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/services/notification/notification_tap_service.dart';

void main() {
  setUp(NotificationTapService.resetForTesting);

  test('keeps a tap pending until navigation consumes it', () {
    NotificationTapService.registerTap();

    expect(NotificationTapService.hasPendingTap, isTrue);
    expect(NotificationTapService.consumePendingTap(), isTrue);
    expect(NotificationTapService.hasPendingTap, isFalse);
    expect(NotificationTapService.consumePendingTap(), isFalse);
  });

  test('emits a tap event to active listeners', () async {
    final event = expectLater(NotificationTapService.taps, emits(null));

    NotificationTapService.registerTap();

    await event;
  });
}
