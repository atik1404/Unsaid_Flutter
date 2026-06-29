import 'package:formz/formz.dart';
import 'package:common/src/enums/validation_error.dart';

/// Formz input that validates an 11-digit phone number.
class NameInputValidator extends FormzInput<String, ValidationError> {
  const NameInputValidator.pure() : super.pure('');
  const NameInputValidator.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) return ValidationError.empty;
    if (value.length < 3) return ValidationError.tooShort;
    if (value.length > 30) return ValidationError.tooLong;
    return null;
  }
}
