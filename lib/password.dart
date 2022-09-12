import 'package:blankpassword/auth.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'create_credential.dart';
import 'credential.dart';

class YourPasswordHomePageWidget extends StatefulWidget {
  const YourPasswordHomePageWidget({super.key});

  @override
  State<YourPasswordHomePageWidget> createState() =>
      _YourPasswordHomePageWidgetState();
}

class _YourPasswordHomePageWidgetState
    extends State<YourPasswordHomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Password"),
        elevation: 0,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWidget(),
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              ),
            child: const Icon(
                    Icons.logout,
                    size: 25,
                    color: Colors.white,
                  ),
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              OutlinedButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.create_new_folder,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
              const Divider(height: 2, thickness: 2),
              const Padding(padding: EdgeInsets.all(2)),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YourPasswordFolderWidget(),
                    ),
                  );
                },
                child: Row(children: [
                  Icon(
                    Icons.folder,
                      size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  const Text("Sosmed"),
                ]),
              ),
              const Padding(padding: EdgeInsets.all(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class YourPasswordFolderWidget extends StatefulWidget {
  const YourPasswordFolderWidget({super.key});

  @override
  State<YourPasswordFolderWidget> createState() =>
      _YourPasswordFolderWidgetState();
}

class _YourPasswordFolderWidgetState extends State<YourPasswordFolderWidget> {
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              OutlinedButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Icon(
                      Icons.folder,
                      size: 50,
                    ),

                    Text("Sosmed"),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
              const Divider(height: 2, thickness: 2),
              const Padding(padding: EdgeInsets.all(2)),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CredentialWidget(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.facebook,
                      color: Colors.black,
                      size: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Facebook",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        Text("qonitaarif5@gmail.com"),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
