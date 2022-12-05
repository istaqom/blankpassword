import 'package:blankpassword/app.dart';
import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:flutter/material.dart';

class CreateFolderWidget extends StatefulWidget {
  const CreateFolderWidget({super.key, required this.bloc});

  final CredentialsBloc bloc;

  @override
  State<CreateFolderWidget> createState() => _CreateFolderWidgetState();
}

class _CreateFolderWidgetState extends State<CreateFolderWidget> {
  final name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppContainer(
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "example@gmail.com",
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await widget.bloc.createFolder(Folder(name: name.text));

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
