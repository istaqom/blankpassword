

import 'package:flutter/material.dart';

import 'app.dart';
import 'create_credential.dart';

class YourPasswordPageWidget extends StatefulWidget {
  const YourPasswordPageWidget({super.key});

  @override
  State<YourPasswordPageWidget> createState() => _YourPasswordPageWidgetState();
}

class _YourPasswordPageWidgetState extends State<YourPasswordPageWidget> {
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
              MaterialPageRoute(
                builder: (context) => const CreateCredentialWidget(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        child: Column(
          children: <Widget>[
            Row(),
          ],
        ),
      ),
    );
  }
}
