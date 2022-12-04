import 'package:blankpassword/app.dart';
import 'package:blankpassword/credential/blocs/credential_bloc.dart';
import 'package:blankpassword/credential/blocs/credential_form_bloc.dart';
import 'package:blankpassword/credential/view/credential_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CredentialFormWidget extends StatelessWidget {
  const CredentialFormWidget({
    super.key,
    this.readOnly = false,
    required this.bloc,
    this.title,
  });

  static Route<void> route({
    bool readOnly = false,
    required CredentialFormBloc bloc,
    Widget? title,
  }) {
    return MaterialPageRoute(
      builder: (context) {
        return CredentialFormWidget(
          key: ObjectKey(bloc.state),
          title: title,
          bloc: bloc,
        );
      },
    );
  }

  final bool readOnly;
  final CredentialFormBloc bloc;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialFormBloc, CredentialFormState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.pop(context, bloc.toCredential());
        }

        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Unkown Error'),
              ),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: title,
            actions: [
              bloc.state.status.isSubmissionInProgress
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        bloc.add(CredentialFormSubmitted());
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text("Save"),
                    ),
            ],
          ),
          body: Builder(
            builder: (context) {
              return AppContainer(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      CredentialInputWidget(
                        bloc: bloc,
                        readOnly: readOnly,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CredentialWidget extends StatelessWidget {
  const CredentialWidget({
    super.key,
    required this.bloc,
  });

  final CredentialBloc bloc;
  static const title = "Your LoginInfo";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialBloc, CredentialState>(
      bloc: bloc,
      listener: (context, state) {
        switch (state.status) {
          case CredentialStatus.unkown:
            break;
          case CredentialStatus.deleted:
            Navigator.pop(context);
            break;
        }
      },
      builder: (context, status) {
        var credential = status.credential;
        return Scaffold(
          appBar: AppBar(
            title: const Text(title),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text("Edit"),
                onPressed: () {
                  Navigator.push(
                    context,
                    CredentialFormWidget.route(
                      title: const Text("Edit Login Info"),
                      bloc: CredentialFormBloc(
                        credentialRepository: CredentialUpdateRepository(
                          bloc,
                        ),
                        state: CredentialFormState.fromCredential(
                          bloc.state.credential,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: AppContainer(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  CredentialInputWidget(
                    key: ObjectKey(credential),
                    readOnly: true,
                    bloc: CredentialFormBloc(
                      credentialRepository: CredentialFormRepository(),
                      state: CredentialFormState.fromCredential(
                        credential,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bloc.delete();
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key, required this.title});

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: const Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
