import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/services/app_date_time_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  test('uses Saturday and 12 hours when nothing is stored', () {
    expect(
      AppDateTimeSettings.weekStartsOn,
      AppDateTimeSettings.defaultWeekStartsOn,
    );
    expect(
      AppDateTimeSettings.timeFormat,
      AppDateTimeSettings.twelveHourFormat,
    );
    expect(AppDateTimeSettings.use24HourFormat, isFalse);
  });

  test('stores normalized date and time settings', () async {
    await AppDateTimeSettings.save(
      weekStartsOn: 'الاثنين',
      timeFormat: '24 ساعة',
    );

    expect(AppDateTimeSettings.weekStartsOn, 'الإتنين');
    expect(AppDateTimeSettings.timeFormat, '24 ساعة');
    expect(AppDateTimeSettings.use24HourFormat, isTrue);
  });

  test(
    'date and time settings survive settings-preserving cache clear',
    () async {
      await CacheHelper.saveData(key: 'temporary_key', value: 'temporary');

      await CacheHelper.clearDataButKeepSettings();

      expect(AppDateTimeSettings.weekStartsOn, 'الإتنين');
      expect(AppDateTimeSettings.timeFormat, '24 ساعة');
      expect(CacheHelper.containsKey(key: 'temporary_key'), isFalse);
    },
  );
}
