import 'package:formz/formz.dart';

enum PasswordValidationError { empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : PasswordValidationError.empty;
  }
}

enum ConfirmPasswordValidationError { empty, unequal }

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure()
      : original = const Password.pure(),
        super.pure('');
  const ConfirmPassword.dirty(this.original, [super.value = ''])
      : super.dirty();

  final Password original;

  @override
  ConfirmPasswordValidationError? validator(String? value) {
    if (original.value != value) {
      return ConfirmPasswordValidationError.unequal;
    }

    return value?.isNotEmpty == true
        ? null
        : ConfirmPasswordValidationError.empty;
  }
}

// enum EqualError {}
// class EqualInput extends FormzInput<String, EqualError> {
//   @override
//   EqualError? validator(String? value) {
//     return password.value == confirmPassword.value ? 
//   }
// }
