import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.labelText, this.controller, this.suffixIcon});
  final TextEditingController? controller;
  final List<Widget>? suffixIcon;
  final String labelText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        icon: const Icon(Icons.password),
        labelText: widget.labelText,
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
            ...widget.suffixIcon ?? [],
          ],
        ),
      ),
      obscureText: !showPassword,
    );
  }
}
