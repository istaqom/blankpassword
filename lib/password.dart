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
              Row(
                children: [
                  Icon(
                    Icons.create_new_folder,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const Divider(height: 2, thickness: 2),
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
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  const Text("Sosmed"),
                ]),
              )
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
              Row(
                children: const [
                  Icon(
                    Icons.folder,
                    size: 100,
                  ),
                  Text("Sosmed"),
                ],
              ),
              const Divider(height: 2, thickness: 2),
              const SizedBox(height: 20),
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
                      size: 100,
                      color: Colors.black,
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
