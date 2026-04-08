import 'package:flutter/foundation.dart';

enum AuthSessionStatus {
  unknown,
  unauthenticated,
  needsEmailVerification,
  needsOnboarding,
  authenticated,
}

class AuthSession extends ChangeNotifier {
  AuthSession({
    AuthSessionStatus initialStatus = AuthSessionStatus.unknown,
  }) : _status = initialStatus;

  AuthSessionStatus _status;

  AuthSessionStatus get status => _status;

  bool get isChecking => _status == AuthSessionStatus.unknown;
  bool get isUnauthenticated =>
      _status == AuthSessionStatus.unauthenticated;
  bool get needsEmailVerification =>
      _status == AuthSessionStatus.needsEmailVerification;
  bool get needsOnboarding =>
      _status == AuthSessionStatus.needsOnboarding;
  bool get isAuthenticated =>
      _status == AuthSessionStatus.authenticated;

  bool get canAccessProtectedRoutes => isAuthenticated;

  void setStatus(AuthSessionStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
  }

  void markChecking() {
    setStatus(AuthSessionStatus.unknown);
  }

  void markUnauthenticated() {
    setStatus(AuthSessionStatus.unauthenticated);
  }

  void markNeedsEmailVerification() {
    setStatus(AuthSessionStatus.needsEmailVerification);
  }

  void markNeedsOnboarding() {
    setStatus(AuthSessionStatus.needsOnboarding);
  }

  void markAuthenticated() {
    setStatus(AuthSessionStatus.authenticated);
  }

  void reset() {
    markUnauthenticated();
  }
}