import 'package:blankpassword/app.dart';
import 'package:flutter/material.dart';

class GeneratePasswordWidget extends StatefulWidget {
  const GeneratePasswordWidget({super.key});

  @override
  State<GeneratePasswordWidget> createState() => _GeneratePasswordWidgetState();
}

class _GeneratePasswordWidgetState extends State<GeneratePasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Password"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, "WOWO");
            },
            child: const Text("Select"),
          ),
        ],
      ),
      body: const AppContainer(
        child: Text("ehe"),
      ),
    );
  }
}
