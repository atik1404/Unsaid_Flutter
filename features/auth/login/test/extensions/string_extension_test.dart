import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtension.formatPhone', () {
    test('returns the string unchanged when it already starts with +88', () {
      expect('+8801712345678'.formatPhone(), '+8801712345678');
    });

    test('prepends +88 when the string starts with 01', () {
      expect('01712345678'.formatPhone(), '+8801712345678');
    });

    test('prepends +88 when string starts with 011', () {
      expect('01112345678'.formatPhone(), '+8801112345678');
    });

    test('returns the string unchanged when it does not start with +88 or 01', () {
      // Raw 11-digit number without leading 01 — no prefix match
      expect('17123456789'.formatPhone(), '17123456789');
    });

    test('returns empty string unchanged', () {
      expect(''.formatPhone(), '');
    });

    test('does not double-prepend when called twice', () {
      final result = '01712345678'.formatPhone().formatPhone();
      expect(result, '+8801712345678');
    });
  });
}
