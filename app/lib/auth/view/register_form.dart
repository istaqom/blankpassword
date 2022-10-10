import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../widget/password_field.dart';
import '../blocs/register_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Column(
        children: [
          EmailInput(bloc: widget.bloc),
          PasswordInput(bloc: widget.bloc),
          ConfirmPasswordInput(bloc: widget.bloc),
          const SizedBox(height: 10),
          RegisterButton(bloc: widget.bloc),
        ],
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: bloc,
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            key: const Key("registerForm_usernameInput_textField"),
            onChanged: (username) =>
                bloc.add(RegisterUsernameChanged(username)),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              labelText: "Email",
              filled: true,
              fillColor: Colors.white,
              hintText: "example@gmail.com",
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: bloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: PasswordField(
            key: const Key("registerForm_passwordInput_textField"),
            labelText: "Password",
            onChanged: (password) => bloc.add(
              RegisterPasswordChanged(password),
            ),
          ),
        );
      },
    );
  }
}

class ConfirmPasswordInput extends StatelessWidget {
  const ConfirmPasswordInput({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: bloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: PasswordField(
            key: const Key("registerForm_confirmPasswordInput_textField"),
            labelText: "Password",
            onChanged: (password) => bloc.add(
              RegisterPasswordChanged(password),
            ),
          ),
        );
      },
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key, required this.bloc});

  final RegisterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: bloc,
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key("registerForm_continue_raisedButton"),
                onPressed: state.status.isValidated
                    ? () {
                        bloc.add(const RegisterSubmitted());
                      }
                    : null,
                child: const Text("Sign Up"),
              );
      },
    );
  }
}
