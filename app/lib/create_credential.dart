import 'package:blankpassword/generate_password.dart';
import 'package:blankpassword/widget/password_field.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:flutter/material.dart';

import 'app.dart';

class CreateCredentialWidget extends StatefulWidget {
  const CreateCredentialWidget({
    super.key,
    this.credential,
  });

  final Credential? credential;

  @override
  State<CreateCredentialWidget> createState() => _CreateCredentialWidgetState();
}

class _CreateCredentialWidgetState extends State<CreateCredentialWidget> {
  final formKey = GlobalKey<FormCredentialWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Login Info"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(
                context,
                formKey.currentState!.toCredential(),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Text("Save"),
          ),
        ],
      ),
      body: AppContainer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FormCredentialWidget(
            key: formKey,
            credential: widget.credential,
          ),
        ),
      ),
    );
  }
}

class FormCredentialWidget extends StatefulWidget {
  const FormCredentialWidget({
    super.key,
    this.credential,
    this.isReadOnly = false,
  });

  final Credential? credential;
  final bool isReadOnly;

  @override
  State<FormCredentialWidget> createState() => FormCredentialWidgetState();
}

class FormCredentialWidgetState extends State<FormCredentialWidget> {
  FormCredentialWidgetState();

  @override
  void initState() {
    var credential = widget.credential;
    if (credential != null) {
      name.text = credential.name;
      username.text = credential.username;
      password.text = credential.password;
      notes.text = credential.notes;
      if (credential.sites.isNotEmpty) {
        sites.clear();
        sites.addAll(
          credential.sites.map(
            (it) => TextEditingController(text: it),
          ),
        );
      }
    }

    super.initState();
  }

  var name = TextEditingController();
  var username = TextEditingController();
  var password = TextEditingController();
  var sites = [TextEditingController()];
  var notes = TextEditingController();

  Credential toCredential() {
    return Credential(
      id: widget.credential?.id ?? '',
      name: name.value.text,
      username: username.value.text,
      password: password.value.text,
      notes: notes.value.text,
      sites: sites.map((it) {
        return it.value.text;
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var readOnly = widget.isReadOnly;
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: name,
            readOnly: readOnly,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.web),
              labelText: "Nama",
              filled: true,
              fillColor: Colors.white,
              hintText: "Nama",
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: username,
            readOnly: readOnly,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: "Username",
              filled: true,
              fillColor: Colors.white,
              hintText: "Username",
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: PasswordField(
            labelText: "Password",
            controller: password,
            readOnly: readOnly,
            suffixIcon: [
              if (!readOnly)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    final String? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeneratePasswordWidget(),
                      ),
                    );

                    if (!mounted) return;
                    // ignore if null
                    if (result == null) return;

                    setState(() {
                      password.text = result;
                    });
                  },
                ),
              // !readOnly
            ],
          ),
        ),
        Column(
          children: [
            for (var i = 0; i < sites.length; ++i)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: sites[i],
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.web),
                    hintText: "URL ${i + 1}",
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    labelText: "URL ${i + 1}",
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: readOnly
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                sites.removeAt(i);
                              });
                            },
                          ),
                  ),
                ),
              ),
          ],
        ),
        if (!readOnly)
          TextButton(
            child: const Text(
              "New Site",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                sites.add(TextEditingController());
              });
            },
          ),
        // !widget.isReadOnly
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: notes,
            readOnly: readOnly,
            decoration: InputDecoration(
              labelText: "Notes",
              filled: true,
              fillColor: Colors.white,
              hintText: "Notes",
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            minLines: 4,
            maxLines: null,
          ),
        )
      ],
    );
  }
}
