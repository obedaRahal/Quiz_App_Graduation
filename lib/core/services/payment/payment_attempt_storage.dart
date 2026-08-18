import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';

class PaymentAttemptStorage {
  static const _attemptIdKey = 'active_payment_attempt_id';
  static const _testIdKey = 'active_payment_test_id';

  Future<void> save({required int attemptId, required int testId}) async {
    await Future.wait([
      CacheHelper.saveData(key: _attemptIdKey, value: attemptId),
      CacheHelper.saveData(key: _testIdKey, value: testId),
    ]);
  }

  int? get attemptId => CacheHelper.getInt(key: _attemptIdKey);
  int? get testId => CacheHelper.getInt(key: _testIdKey);

  Future<void> clear() async {
    await Future.wait([
      CacheHelper.removeData(key: _attemptIdKey),
      CacheHelper.removeData(key: _testIdKey),
    ]);
  }
}
