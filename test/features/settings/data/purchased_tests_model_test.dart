import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/features/settings/data/models/purchased_tests_model.dart';

void main() {
  test('parses purchased tests response', () {
    final model = PurchasedTestsModel.fromJson({
      'success': true,
      'title': 'تم جلب الاختبارات المشتراة بنجاح',
      'status_code': 200,
      'data': [
        {
          'id': 2,
          'title': 'اختبار الهندسة الكهربائية',
          'description': 'وصف تدريبي للاختبار.',
          'interests': ['الهندسة الكهربائية'],
          'difficulty_level': 'سهل',
          'average_rating': 3,
          'price': '4550.00',
          'published_at': '25 March 2026',
          'question_count': 19,
          'purchased_at': '2026-08-05 15:25:26',
        },
      ],
    });

    expect(model.success, isTrue);
    expect(model.statusCode, 200);
    expect(model.tests, hasLength(1));
    expect(model.tests.single.id, 2);
    expect(model.tests.single.averageRating, 3.0);
    expect(model.tests.single.interests, ['الهندسة الكهربائية']);
  });
}
