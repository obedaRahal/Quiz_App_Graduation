import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/utils/app_logger.dart';

void main() {
  test('redacts authentication values while preserving flow messages', () {
    const sensitiveMessage =
        'request: {email: user@example.com, password: secret123, '
        'otp_code: 123456, access_token: abc.def.ghi, '
        'authorization: Bearer bearer-token}';

    final redacted = AppLogger.redactForTesting(sensitiveMessage);

    expect(redacted, contains('request:'));
    expect(redacted, contains('[REDACTED]'));
    expect(redacted, isNot(contains('user@example.com')));
    expect(redacted, isNot(contains('secret123')));
    expect(redacted, isNot(contains('123456')));
    expect(redacted, isNot(contains('abc.def.ghi')));
    expect(redacted, isNot(contains('bearer-token')));
  });

  test('leaves non-sensitive diagnostic messages unchanged', () {
    const message = 'Login request started (attempt: 1)';

    expect(AppLogger.redactForTesting(message), message);
  });

  test('redacts an FCM token printed with an availability label', () {
    const token = 'abc123:APA91bExampleSensitiveValue';
    const message = 'initial FCM token available: $token';

    final redacted = AppLogger.redactForTesting(message);

    expect(redacted, contains('[REDACTED]'));
    expect(redacted, isNot(contains(token)));
  });
}
