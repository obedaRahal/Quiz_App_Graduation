import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/errors/error_model.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';

void main() {
  group('ErrorModel.fromResponseData', () {
    test('decodes a JSON validation response returned as bytes', () {
      final responseBytes = utf8.encode(
        '{"message":"The given data was invalid.",'
        '"errors":{"content_id":["لا يمكن تحميل هذا المحتوى."]}}',
      );

      final result = ErrorModel.fromResponseData(
        responseBytes,
        fallbackStatusCode: 422,
      );

      expect(result.status, 422);
      expect(result.errorMessage, 'لا يمكن تحميل هذا المحتوى.');
    });

    test('joins validation messages without duplicates', () {
      final result = ErrorModel.fromResponseData({
        'status': 422,
        'errors': {
          'first': ['الرسالة الأولى', 'الرسالة الأولى'],
          'second': ['الرسالة الثانية'],
        },
      });

      expect(result.errorMessage, 'الرسالة الأولى\nالرسالة الثانية');
    });

    test('uses a plain-text byte response as the error message', () {
      final result = ErrorModel.fromResponseData(
        utf8.encode('تعذر تنزيل الملف'),
        fallbackStatusCode: 500,
      );

      expect(result.status, 500);
      expect(result.errorMessage, 'تعذر تنزيل الملف');
    });
  });

  test(
    'handleDioException preserves validation errors from byte responses',
    () {
      final requestOptions = RequestOptions(path: '/content/1/download');
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<List<int>>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: utf8.encode(
            '{"errors":{"content":["هذا المحتوى غير متاح للتحميل."]}}',
          ),
        ),
      );

      expect(
        () => handleDioException(exception),
        throwsA(
          isA<ValidationException>().having(
            (error) => error.errorModel.errorMessage,
            'message',
            'هذا المحتوى غير متاح للتحميل.',
          ),
        ),
      );
    },
  );
}
