part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUsernameChanged extends RegisterEvent {
  const RegisterUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  const RegisterConfirmPasswordChanged(this.confirmPassword);

  final String confirmPassword;

  @override
  List<Object> get props => [confirmPassword];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
