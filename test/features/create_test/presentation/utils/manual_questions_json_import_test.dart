import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/features/create_test/presentation/utils/manual_questions_json_import.dart';

void main() {
  Uint8List jsonBytes(Object value) {
    return Uint8List.fromList(utf8.encode(jsonEncode(value)));
  }

  test('parses valid multiple-choice questions', () {
    final result = parseManualQuestionsJson(
      jsonBytes({
        'questions': [
          {
            'question': 'ما هي عاصمة الجمهورية العربية السورية؟',
            'options': ['دمشق', 'حلب', 'حمص'],
            'correctOptionIndex': 0,
            'explanation': 'دمشق هي العاصمة.',
          },
        ],
      }),
    );

    expect(result.isSuccess, isTrue);
    expect(result.questions, hasLength(1));
    expect(result.questions.single.correctOptionIndex, 0);
    expect(result.questions.single.options, ['دمشق', 'حلب', 'حمص']);
  });

  test('rejects a question with an invalid correct option index', () {
    final result = parseManualQuestionsJson(
      jsonBytes({
        'questions': [
          {
            'question': 'ما هي عاصمة الجمهورية العربية السورية؟',
            'options': ['دمشق', 'حلب'],
            'correctOptionIndex': 2,
          },
        ],
      }),
    );

    expect(result.isSuccess, isFalse);
    expect(result.error, contains('correctOptionIndex'));
  });

  test('rejects invalid JSON text', () {
    final result = parseManualQuestionsJson(
      Uint8List.fromList(utf8.encode('{questions:[]}')),
    );

    expect(result.isSuccess, isFalse);
    expect(result.error, isNotEmpty);
  });
}
