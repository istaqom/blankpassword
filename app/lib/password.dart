import 'package:authentication_repository/authentication_repository.dart';
import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:blankpassword/credential/blocs/credential_form_bloc.dart';
import 'package:blankpassword/credential/view/credential_widget.dart';
import 'package:blankpassword/credential/view/credential_list.dart';
import 'package:blankpassword/settings.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

class YourPasswordHomePageWidget extends StatefulWidget {
  const YourPasswordHomePageWidget({
    super.key,
    required this.authenticationRepository,
    required this.credentialRepository,
    required this.bloc,
  });

  final AuthenticationRepository authenticationRepository;
  final CredentialsBloc bloc;
  final CredentialRepository credentialRepository;

  @override
  State<YourPasswordHomePageWidget> createState() =>
      _YourPasswordHomePageWidgetState();
}

class _YourPasswordHomePageWidgetState
    extends State<YourPasswordHomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Password"),
        elevation: 0,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountSettings(
                    authenticationRepository: widget.authenticationRepository,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Icon(
              Icons.person,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: AppContainerWithFloatingButton(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              CredentialFormWidget.route(
                bloc: CredentialFormBloc(
                  credentialRepository: CredentialCreateRepository(
                    widget.bloc,
                  ),
                ),
                title: const Text("Add Login Info"),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Colors.transparent,
                )),
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.create_new_folder,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Create New Folder",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
              const Divider(height: 2, thickness: 2),
              const Padding(padding: EdgeInsets.all(2)),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Colors.transparent,
                )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YourPasswordFolderWidget(
                        bloc: widget.bloc,
                        credentialRepository: widget.credentialRepository,
                      ),
                    ),
                  );
                },
                child: Row(children: [
                  Icon(
                    Icons.folder,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Sosmed",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
              ),
              const Padding(padding: EdgeInsets.all(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class YourPasswordFolderWidget extends StatefulWidget {
  YourPasswordFolderWidget({
    super.key,
    required this.bloc,
    required this.credentialRepository,
  }) {
    bloc.loadCredential();
  }

  final CredentialsBloc bloc;
  final CredentialRepository credentialRepository;

  @override
  State<YourPasswordFolderWidget> createState() =>
      _YourPasswordFolderWidgetState();
}

class _YourPasswordFolderWidgetState extends State<YourPasswordFolderWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Password"),
        elevation: 0,
      ),
      body: AppContainerWithFloatingButton(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              CredentialFormWidget.route(
                bloc: CredentialFormBloc(
                  credentialRepository: CredentialCreateRepository(
                    widget.bloc,
                  ),
                ),
                title: const Text("Add Login Info"),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
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
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Sosmed",
                            style: TextStyle(
                              color: Colors.white,
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
                        bloc: widget.bloc,
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
