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
        TextField(
          controller: name,
          decoration: const InputDecoration(
            icon: Icon(Icons.web),
            labelText: "Name",
            hintText: "Facebook",
          ),
        ),
        TextField(
          controller: username,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            labelText: "Username",
            hintText: "example@example.com",
          ),
        ),
        PasswordField(
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
        Column(
          children: [
            for (var i = 0; i < sites.length; ++i)
              TextField(
                controller: sites[i],
                decoration: InputDecoration(
                  icon: const Icon(Icons.web),
                  labelText: "URL ${i + 1}",
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
          ],
        ),
        TextButton(
          child: const Text("New Site"),
          onPressed: () {
            setState(() {
              sites.add(TextEditingController());
            });
          },
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(
            label: Text("Notes"),
          ),
          minLines: 4,
          maxLines: null,
        )
      ],
    );
  }
}
