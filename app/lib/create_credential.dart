import 'package:blankpassword/generate_password.dart';
import 'package:blankpassword/widget/password_field.dart';
import 'package:flutter/material.dart';

import 'app.dart';

class CreateCredentialWidget extends StatefulWidget {
  const CreateCredentialWidget({super.key});

  @override
  State<CreateCredentialWidget> createState() => _CreateCredentialWidgetState();
}

class _CreateCredentialWidgetState extends State<CreateCredentialWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Login Info"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Text("Save"),
          ),
        ],
      ),
      body: const AppContainer(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CreateCredentialFormWidget(),
        ),
      ),
    );
  }
}

class CreateCredentialFormWidget extends StatefulWidget {
  const CreateCredentialFormWidget({super.key});

  @override
  State<CreateCredentialFormWidget> createState() =>
      CreateCredentialFormWidgetState();
}

class CreateCredentialFormWidgetState
    extends State<CreateCredentialFormWidget> {
  var name = TextEditingController();
  var username = TextEditingController();
  var password = TextEditingController();
  var sites = [TextEditingController()];
  var notes = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: name,
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
            suffixIcon: [
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
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.web),
                    hintText: "URL ${i + 1}",
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    labelText: "URL ${i + 1}",
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
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
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: notes,
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
