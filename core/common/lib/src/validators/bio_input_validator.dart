import 'package:formz/formz.dart';
import 'package:common/src/enums/validation_error.dart';

/// Formz input for an optional biography.
///
/// An empty value is valid (the field is optional); only the maximum length
/// enforced by the API is validated.
class BioInputValidator extends FormzInput<String, ValidationError> {
  const BioInputValidator.pure() : super.pure('');
  const BioInputValidator.dirty([super.value = '']) : super.dirty();

  /// Maximum number of characters the API accepts for a bio.
  static const int maxLength = 160;

  @override
  ValidationError? validator(String value) {
    if (value.length > maxLength) return ValidationError.tooLong;
    return null;
  }
}
