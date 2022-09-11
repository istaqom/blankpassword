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
  var sites = ["instagram.com"];
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
              TextField(
                controller: TextEditingController(text: name),
                readOnly: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.web),
                  labelText: "Name",
                  hintText: "Facebook",
                ),
              ),
              TextField(
                controller: TextEditingController(text: username),
                readOnly: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "Username",
                  hintText: "example@example.com",
                ),
              ),
              PasswordField(
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
              Column(
                children: [
                  for (var i = 0; i < sites.length; ++i)
                    TextField(
                      controller: TextEditingController(text: sites[i]),
                      readOnly: true,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.web),
                        labelText: "URL ${i + 1}",
                      ),
                    ),
                ],
              ),
              TextField(
                controller: TextEditingController(text: notes),
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text("Notes"),
                ),
                minLines: 4,
                maxLines: null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
