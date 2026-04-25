import 'package:flutter/foundation.dart';

enum AuthSessionStatus { unknown, unauthenticated, authenticated }

class AuthSession extends ChangeNotifier {
  AuthSession({AuthSessionStatus initialStatus = AuthSessionStatus.unknown})
    : _status = initialStatus;

  AuthSessionStatus _status;

  AuthSessionStatus get status => _status;

  bool get isChecking => _status == AuthSessionStatus.unknown;
  bool get isUnauthenticated => _status == AuthSessionStatus.unauthenticated;
  bool get isAuthenticated => _status == AuthSessionStatus.authenticated;

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

  void markAuthenticated() {
    setStatus(AuthSessionStatus.authenticated);
  }

  void reset() {
    markUnauthenticated();
  }
}
