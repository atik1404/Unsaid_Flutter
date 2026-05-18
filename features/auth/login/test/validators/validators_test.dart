import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneInputValidator', () {
    test('pure() is marked pure and is not valid', () {
      const input = PhoneInputValidator.pure();
      expect(input.isPure, isTrue);
      expect(input.isValid, isFalse);
    });

    test('dirty empty string returns ValidationError.empty', () {
      const input = PhoneInputValidator.dirty();
      expect(input.error, ValidationError.empty);
      expect(input.isValid, isFalse);
    });

    test('dirty with fewer than 11 digits returns ValidationError.invalid', () {
      const input = PhoneInputValidator.dirty('017123456'); // 9 digits
      expect(input.error, ValidationError.invalid);
      expect(input.isValid, isFalse);
    });

    test('dirty with more than 11 digits returns ValidationError.invalid', () {
      const input = PhoneInputValidator.dirty('017123456789'); // 12 digits
      expect(input.error, ValidationError.invalid);
      expect(input.isValid, isFalse);
    });

    test('dirty with non-digit characters returns ValidationError.invalid', () {
      const input = PhoneInputValidator.dirty('0171234567a');
      expect(input.error, ValidationError.invalid);
      expect(input.isValid, isFalse);
    });

    test('dirty with exactly 11 digits is valid', () {
      const input = PhoneInputValidator.dirty('01712345678');
      expect(input.error, isNull);
      expect(input.isValid, isTrue);
    });

    test('dirty with exactly 11 digits starting with 011 is valid', () {
      const input = PhoneInputValidator.dirty('01112345678');
      expect(input.isValid, isTrue);
    });
  });

  group('PasswordInputValidator', () {
    test('pure() is marked pure and is not valid', () {
      const input = PasswordInputValidator.pure();
      expect(input.isPure, isTrue);
      expect(input.isValid, isFalse);
    });

    test('dirty empty string returns ValidationError.empty', () {
      const input = PasswordInputValidator.dirty();
      expect(input.error, ValidationError.empty);
      expect(input.isValid, isFalse);
    });

    test('dirty with fewer than 6 characters returns ValidationError.tooShort', () {
      const input = PasswordInputValidator.dirty('12345'); // 5 chars
      expect(input.error, ValidationError.tooShort);
      expect(input.isValid, isFalse);
    });

    test('dirty with exactly 6 characters is valid', () {
      const input = PasswordInputValidator.dirty('123456');
      expect(input.error, isNull);
      expect(input.isValid, isTrue);
    });

    test('dirty with more than 6 characters is valid', () {
      const input = PasswordInputValidator.dirty('supersecret');
      expect(input.error, isNull);
      expect(input.isValid, isTrue);
    });

    test('dirty with 1 character returns ValidationError.tooShort', () {
      const input = PasswordInputValidator.dirty('a');
      expect(input.error, ValidationError.tooShort);
      expect(input.isValid, isFalse);
    });
  });
}
