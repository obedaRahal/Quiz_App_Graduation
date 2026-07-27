import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';

void main() {
  test('stores a protected location until authentication consumes it', () {
    final session = AuthSession();

    session.rememberProtectedLocation('/share/profiles/profile-slug');

    expect(session.pendingProtectedLocation, '/share/profiles/profile-slug');
    expect(
      session.takePendingProtectedLocation(),
      '/share/profiles/profile-slug',
    );
    expect(session.pendingProtectedLocation, isNull);
  });

  test('reset clears authentication and any pending location', () {
    final session = AuthSession(initialStatus: AuthSessionStatus.authenticated)
      ..rememberProtectedLocation('/shared-test/test-slug');

    session.reset();

    expect(session.isUnauthenticated, isTrue);
    expect(session.pendingProtectedLocation, isNull);
  });
}
