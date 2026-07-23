import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/features/auth/data/models/login_models/login_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/login_models/login_response_model.dart';

void main() {
  group('LoginRequestModel', () {
    test('sends credentials and available device metadata', () {
      const request = LoginRequestModel(
        email: 'user@example.com',
        password: 'secret',
        fcmToken: 'fcm-token',
        deviceId: 'installation-id',
        deviceName: 'ASUS Phone',
      );

      expect(request.toJson(), {
        'email': 'user@example.com',
        'password': 'secret',
        'fcm_token': 'fcm-token',
        'device_id': 'installation-id',
        'device_name': 'ASUS Phone',
      });
    });

    test('omits unavailable optional device metadata', () {
      const request = LoginRequestModel(
        email: 'user@example.com',
        password: 'secret',
        fcmToken: ' ',
      );

      expect(request.toJson(), {
        'email': 'user@example.com',
        'password': 'secret',
      });
    });
  });

  test('LoginResponseModel parses and exposes the returned user id', () {
    final response = LoginResponseModel.fromJson({
      'success': true,
      'title': 'تم تسجيل الدخول بنجاح',
      'data': {
        'user': {'id': '1', 'name': 'محمد منصور', 'gender': 'ذكر'},
        'token': 'jwt-token',
        'expires_in': 22800,
      },
    }).toEntity();

    expect(response.user.id, 1);
    expect(response.user.name, 'محمد منصور');
    expect(response.token, 'jwt-token');
    expect(response.expiresIn, 22800);
  });
}
