import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/main.dart';

void main() {
  test('QuizApp keeps optional alarm integration disabled by default', () {
    expect(const QuizApp().alarmReady, isFalse);
  });
}
