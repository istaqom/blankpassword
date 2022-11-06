import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';

import '../model/model.dart';

part 'register_state.dart';
part 'register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        status: Formz.validate(
            [state.username, state.password, state.confirmPassword]),
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = Password.dirty(event.password);
    final confirmPassword = ConfirmPassword.dirty(
      password,
      state.confirmPassword.value,
    );

    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.username, password, confirmPassword]),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final confirmPassword = ConfirmPassword.dirty(
      state.password,
      event.confirmPassword,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        status: Formz.validate(
          [state.username, state.password, confirmPassword],
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.signUp(
          email: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (e) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            error: e.toString(),
          ),
        );
      }
    }
  }
}
