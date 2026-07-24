import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/features/settings/data/models/settings_operation_response_model.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/logout_params.dart';

void main() {
  group('SettingsOperationResponseModel', () {
    test('parses loose API scalar types safely', () {
      final model = SettingsOperationResponseModel.fromJson({
        'success': '1',
        'title': 123,
        'message': null,
        'status_code': '200',
      });

      expect(model.success, isTrue);
      expect(model.title, '123');
      expect(model.message, isEmpty);
      expect(model.statusCode, 200);
    });
  });

  group('LogoutParams', () {
    test('always sends empty device values required by logout API', () {
      const params = LogoutParams(fcmToken: ' ', deviceId: null);

      expect(params.toJson(), {'fcm_token': '', 'device_id': ''});
    });

    test('trims and sends available device values', () {
      const params = LogoutParams(fcmToken: ' token ', deviceId: ' device ');

      expect(params.toJson(), {'fcm_token': 'token', 'device_id': 'device'});
    });
  });
}
