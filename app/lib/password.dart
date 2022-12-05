import 'package:authentication_repository/authentication_repository.dart';
import 'package:blankpassword/create_folder.dart';
import 'package:blankpassword/credential/blocs/credential_bloc.dart';
import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:blankpassword/credential/blocs/credential_form_bloc.dart';
import 'package:blankpassword/credential/blocs/credentials_folder_bloc.dart';
import 'package:blankpassword/credential/model/model.dart';
import 'package:blankpassword/credential/view/credential_widget.dart';
import 'package:blankpassword/credential/view/credential_list.dart';
import 'package:blankpassword/folder_list.dart';
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

  static Route<void> route({
    required CredentialsBloc bloc,
    required AuthenticationRepository authenticationRepository,
    required CredentialRepository credentialRepository,
  }) {
    return MaterialPageRoute(
      builder: (context) => BlocBuilder<CredentialsBloc, CredentialsState>(
        bloc: bloc,
        builder: (context, state) {
          return YourPasswordHomePageWidget(
            authenticationRepository: authenticationRepository,
            credentialRepository: credentialRepository,
            bloc: bloc,
          );
        },
      ),
    );
  }

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
  void initState() {
    widget.bloc.reload();
    super.initState();
  }

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
                  credentialsbloc: widget.bloc,
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
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateFolderWidget(
                          bloc: widget.bloc,
                        );
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.create_new_folder,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Create New Folder",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
              const Divider(height: 2, thickness: 2),
              const Padding(padding: EdgeInsets.all(2)),
              const Padding(padding: EdgeInsets.all(2)),
              FolderListWidget(
                folders: widget.bloc.state.folders,
                onFolderPressed: (item) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return YourPasswordFolderWidget(
                          bloc: CredentialsFolderBloc(
                            folder: item,
                            credentialsBloc: widget.bloc,
                          ),
                          credentialRepository: widget.credentialRepository,
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class YourPasswordFolderWidget extends StatefulWidget {
  const YourPasswordFolderWidget({
    super.key,
    required this.bloc,
    required this.credentialRepository,
  });

  final CredentialsFolderBloc bloc;
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
                  state: CredentialFormState(
                    folders: [
                      FolderInput(folder: widget.bloc.state.folder),
                    ],
                  ),
                  credentialsbloc: widget.bloc.credentialsBloc,
                  credentialRepository: CredentialCreateRepository(
                    widget.bloc.credentialsBloc,
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
                      ),
                    ),
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
                    bloc: widget.bloc.credentialsBloc,
                    builder: (context, state) {
                      return CredentialListWidget(
                        credentials: widget.bloc.state.credentials,
                        onCredentialPressed: (item) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CredentialWidget(
                                  bloc: CredentialBloc(
                                    credentialBloc: widget.bloc.credentialsBloc,
                                    credential: item,
                                  ),
                                );
                              },
                            ),
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
