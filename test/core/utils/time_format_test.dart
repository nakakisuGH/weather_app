import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/utils/time_format.dart';

void main() {
  DateTime at(int hour, int minute) => DateTime(2026, 10, 29, hour, minute);

  test('formats a morning time', () {
    expect(formatTime12h(at(11, 0)), '11:00 AM');
  });

  test('formats an afternoon time with two-digit hours', () {
    expect(formatTime12h(at(15, 30)), '03:30 PM');
  });

  test('pads single-digit hours and minutes', () {
    expect(formatTime12h(at(9, 5)), '09:05 AM');
  });

  test('shows midnight as 12 AM', () {
    expect(formatTime12h(at(0, 5)), '12:05 AM');
  });

  test('shows noon as 12 PM', () {
    expect(formatTime12h(at(12, 0)), '12:00 PM');
  });

  test('shows a placeholder when the time is missing', () {
    expect(formatTime12h(null), '--:--');
  });
}
