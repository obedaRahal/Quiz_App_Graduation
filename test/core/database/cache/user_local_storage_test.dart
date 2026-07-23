import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/database/cache/user_local_storage.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('saveUserInfo persists the user id with name and gender', () async {
    await UserLocalStorage.saveUserInfo(
      id: 1,
      name: 'محمد منصور',
      gender: 'ذكر',
    );

    expect(await UserLocalStorage.getUserId(), 1);
    expect(await UserLocalStorage.getUserName(), 'محمد منصور');
    expect(await UserLocalStorage.getUserGender(), 'ذكر');
  });

  test('clear removes the stored user id', () async {
    await UserLocalStorage.saveUserInfo(
      id: 1,
      name: 'محمد منصور',
      gender: 'ذكر',
    );

    await UserLocalStorage.clear();

    expect(await UserLocalStorage.getUserId(), isNull);
    expect(await UserLocalStorage.getUserName(), isNull);
    expect(await UserLocalStorage.getUserGender(), isNull);
  });
}
