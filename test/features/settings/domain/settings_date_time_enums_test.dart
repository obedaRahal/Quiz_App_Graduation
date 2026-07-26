import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/features/settings/domain/enums/settings_date_time_enums.dart';

void main() {
  test('uses the agreed 12-hour fallback for an unknown value', () {
    expect(appTimeFormatFromApi(''), AppTimeFormat.twelveHours);
    expect(appTimeFormatFromApi('unknown'), AppTimeFormat.twelveHours);
  });
}
