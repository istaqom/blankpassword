import 'package:authentication_repository/authentication_repository.dart';
import 'package:blankpassword/app.dart';
import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:blankpassword/credential/view/credential_list.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autofill_service/flutter_autofill_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutofillPasswordWidget extends StatefulWidget {
  const AutofillPasswordWidget({
    super.key,
    required this.authenticationRepository,
    required this.credentialRepository,
    required this.bloc,
  });

  final AuthenticationRepository authenticationRepository;
  final CredentialsBloc bloc;
  final CredentialRepository credentialRepository;

  static Route<void> route({
    required CredentialsBloc bloc,
    required AuthenticationRepository authenticationRepository,
    required CredentialRepository credentialRepository,
  }) {
    return MaterialPageRoute(
      builder: (context) => BlocBuilder<CredentialsBloc, CredentialsState>(
        bloc: bloc,
        builder: (context, state) {
          return AutofillPasswordWidget(
            authenticationRepository: authenticationRepository,
            credentialRepository: credentialRepository,
            bloc: bloc,
          );
          //
        },
      ),
    );
  }

  @override
  State<AutofillPasswordWidget> createState() => _AutofillPasswordWidgetState();
}

class _AutofillPasswordWidgetState extends State<AutofillPasswordWidget> {
  @override
  void initState() {
    widget.bloc.loadCredential();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Password"),
        elevation: 0,
      ),
      body: AppContainer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RefreshIndicator(
            onRefresh: () async {
              widget.bloc.reload();
            },
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView(
                children: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                      color: Colors.transparent,
                    )),
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Icon(
                          Icons.folder,
                          size: 50,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Sosmed",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(2)),
                  const Divider(height: 2, thickness: 2),
                  const Padding(padding: EdgeInsets.all(2)),
                  BlocBuilder<CredentialsBloc, CredentialsState>(
                    bloc: widget.bloc,
                    builder: (context, state) {
                      return CredentialListWidget(
                        credentials: widget.bloc.state.credentials,
                        onCredentialPressed: (item) async {
                          var service = AutofillService();

                          final response = await service.resultWithDataset(
                            label: item.name,
                            username: item.username,
                            password: item.password,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
