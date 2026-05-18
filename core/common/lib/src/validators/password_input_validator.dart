import 'package:common/src/enums/validation_error.dart';
import 'package:formz/formz.dart';

/// Formz input that validates a password (min 6 characters).
class PasswordInputValidator extends FormzInput<String, ValidationError> {
  const PasswordInputValidator.pure() : super.pure('');
  const PasswordInputValidator.dirty([super.value = '']) : super.dirty();

  static const _minLength = 6;

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) return ValidationError.empty;
    if (value.length < _minLength) return ValidationError.tooShort;
    return null;
  }
}
