import 'package:blankpassword/app.dart';
import 'package:blankpassword/widget/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var oldpassword = TextEditingController();
  var newpassword = TextEditingController();
  var confirmnew = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        elevation: 0,
      ),
      body: AppContainer(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: PasswordField(
                              labelText: "Old Password",
                              controller: oldpassword)),
                      const Padding(padding: EdgeInsets.all(2)),
                      const Divider(height: 2, thickness: 2),
                      const Padding(padding: EdgeInsets.all(2)),
                      Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: PasswordField(
                              labelText: "New Password",
                              controller: newpassword)),
                      Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: PasswordField(
                              labelText: "Confirm New Password",
                              controller: confirmnew)),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: const Text("save"))
              ],
            )),
      ),
    );
  }
}
