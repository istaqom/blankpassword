import 'package:blankpassword/generate_password.dart';
import 'package:flutter/material.dart';

import 'app.dart';

class CreateCredentialWidget extends StatefulWidget {
  const CreateCredentialWidget({super.key});

  @override
  State<CreateCredentialWidget> createState() => _CreateCredentialWidgetState();
}

class _CreateCredentialWidgetState extends State<CreateCredentialWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Login Info"),
        actions: [
          ElevatedButton(
            onPressed: () {
              print("pressed");
            },
            child: const Text("Save"),
          ),
        ],
      ),
      body: AppContainer(
        child: Form(
          key: _formKey,
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: CreateCredentialFormWidget(),
          ),
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
  var password = TextEditingController();
  var sites = [TextEditingController()];
  var notes = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        TextFormField(
          controller: name,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            labelText: "Username",
            hintText: "example@example.com",
          ),
        ),
        TextFormField(
          controller: password,
          decoration: InputDecoration(
            icon: const Icon(Icons.password),
            labelText: "Password",
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Builder(builder: (context) {
                    if (showPassword) {
                      return const Icon(Icons.visibility_off);
                    } else {
                      return const Icon(Icons.visibility);
                    }
                  }),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
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
          obscureText: !showPassword,
        ),
        Column(
          children: [
            for (var i = 0; i < sites.length; ++i)
              TextFormField(
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
