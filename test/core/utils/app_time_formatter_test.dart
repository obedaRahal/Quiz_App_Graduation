import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/utils/app_time_formatter.dart';

void main() {
  group('AppTimeFormatter', () {
    test('formats API time using the 24-hour preference', () {
      expect(AppTimeFormatter.format('00:05', use24HourFormat: true), '00:05');
      expect(
        AppTimeFormatter.format('23:07:00', use24HourFormat: true),
        '23:07',
      );
    });

    test('formats API time using the Arabic 12-hour preference', () {
      expect(
        AppTimeFormatter.format('00:05', use24HourFormat: false),
        '12:05 ص',
      );
      expect(
        AppTimeFormatter.format('13:07:00', use24HourFormat: false),
        '1:07 م',
      );
    });

    test('parses Arabic 12-hour display values', () {
      expect(
        AppTimeFormatter.tryParse('12:30 ص'),
        const TimeOfDay(hour: 0, minute: 30),
      );
      expect(
        AppTimeFormatter.tryParse('7:45 م'),
        const TimeOfDay(hour: 19, minute: 45),
      );
    });

    test('keeps the API value independent from the display preference', () {
      expect(
        AppTimeFormatter.toApiValue(const TimeOfDay(hour: 7, minute: 5)),
        '07:05',
      );
    });

    test('returns an unrecognized value without changing it', () {
      expect(
        AppTimeFormatter.format('وقت غير صالح', use24HourFormat: false),
        'وقت غير صالح',
      );
    });
  });
}
