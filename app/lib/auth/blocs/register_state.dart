part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.error,
  });

  final String? error;
  final FormzStatus status;
  final Username username;
  final Password password;
  final ConfirmPassword confirmPassword;

  RegisterState copyWith({
    FormzStatus? status,
    String? error,
    Username? username,
    Password? password,
    ConfirmPassword? confirmPassword,
  }) {
    return RegisterState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      error: error,
    );
  }

  @override
  List<Object> get props => [status, username, password];
}
