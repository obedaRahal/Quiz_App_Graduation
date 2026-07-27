import 'dart:async';

import 'package:flutter/foundation.dart';

abstract final class NotificationTapService {
  static final StreamController<void> _tapController =
      StreamController<void>.broadcast(sync: true);

  static bool _hasPendingTap = false;

  static Stream<void> get taps => _tapController.stream;

  static bool get hasPendingTap => _hasPendingTap;

  static void registerTap() {
    _hasPendingTap = true;
    _tapController.add(null);
  }

  static bool consumePendingTap() {
    if (!_hasPendingTap) {
      return false;
    }

    _hasPendingTap = false;
    return true;
  }

  @visibleForTesting
  static void resetForTesting() {
    _hasPendingTap = false;
  }
}
