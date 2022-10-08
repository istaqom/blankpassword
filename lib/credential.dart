import 'package:blankpassword/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widget/password_field.dart';

class CredentialWidget extends StatefulWidget {
  const CredentialWidget({super.key});

  @override
  State<CredentialWidget> createState() => _CredentialWidgetState();
}

class _CredentialWidgetState extends State<CredentialWidget> {
  var name = "Facebook";
  var username = "qonythazu";
  var password = "password";
  var sites = ["facebook.com"];
  var notes = "Akun facebook buat bisnis";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Login Info"),
      ),
      body: AppContainer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: TextEditingController(text: name),
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Nama",
                      prefixIcon: const Icon(Icons.web),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Nama",
                      hintStyle:
                          TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: TextEditingController(text: username),
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Username",
                      hintStyle:
                          TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: PasswordField(
                  labelText: "Password",
                  controller: TextEditingController(text: password),
                  readOnly: true,
                  suffixIcon: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(text: password)).then(
                          (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Password copied to clipboard"),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  for (var i = 0; i < sites.length; ++i)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: TextEditingController(text: sites[i]),
                        readOnly: true,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.web),
                            labelText: "URL ${i + 1}",
                            filled: true,
                            fillColor: Colors.white),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: TextEditingController(text: notes),
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Notes",
                      filled: true,
                      fillColor: Colors.white),
                  minLines: 4,
                  maxLines: null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
