import 'package:formz/formz.dart';

class NoError {
//
}

class GenericInput extends FormzInput<String, NoError> {
  const GenericInput.pure() : super.pure('');
  const GenericInput.dirty([super.value = '']) : super.dirty();

  @override
  NoError? validator(String value) {
    return null;
  }
}
