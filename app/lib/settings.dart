import 'package:authentication_repository/authentication_repository.dart';
import 'package:blankpassword/app.dart';
import 'package:blankpassword/auth.dart';
import 'package:blankpassword/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key, required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
        elevation: 0,
      ),
      body: AppContainer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const ChangePassword(),
                      )
                    );
                  }, 
                  child: Row(
                    children: [
                      Icon(Icons.tune),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Change Password"),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await widget.authenticationRepository.logOut();
                  }, 
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Logout"),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}