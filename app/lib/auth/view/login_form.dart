import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../widget/password_field.dart';
import '../blocs/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.bloc});

  final LoginBloc bloc;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
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
          const SizedBox(height: 10),
          LoginButton(bloc: widget.bloc),
        ],
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: bloc,
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            key: const Key("loginForm_usernameInput_textField"),
            onChanged: (username) => bloc.add(LoginUsernameChanged(username)),
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

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: bloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: PasswordField(
            key: const Key("loginForm_passwordInput_textField"),
            labelText: "Password",
            onChanged: (password) => bloc.add(LoginPasswordChanged(password)),
          ),
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.bloc});

  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: bloc,
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key("loginForm_continue_raisedButton"),
                onPressed: state.status.isValidated
                    ? () {
                        bloc.add(const LoginSubmitted());
                      }
                    : null,
                child: const Text("Login"),
              );
      },
    );
  }
}
