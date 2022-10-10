import 'package:authentication_repository/authentication_repository.dart';
import 'package:blankpassword/auth.dart';
import 'package:blankpassword/settings.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'create_credential.dart';
import 'credential.dart';

class YourPasswordHomePageWidget extends StatefulWidget {
  const YourPasswordHomePageWidget({super.key, required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  AccountSettings(authenticationRepository: widget.authenticationRepository,),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Icon(
              Icons.person,
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
          child: ListView(
            children: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Colors.transparent,
                )),
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.create_new_folder,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Create New Folder",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
              const Divider(height: 2, thickness: 2),
              const Padding(padding: EdgeInsets.all(2)),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Colors.transparent,
                )),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Sosmed",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
          child: ListView(
            children: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                  color: Colors.transparent,
                )),
                onPressed: () {},
                child: Row(
                  children: const [
                    Icon(
                      Icons.folder,
                      size: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Sosmed",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
              const Divider(height: 2, thickness: 2),
              const Padding(padding: EdgeInsets.all(2)),
              for (var _ in List<int>.generate(20, (i) => i))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                      color: Colors.transparent,
                    )),
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
                          color: Color(0xff472D2D),
                          size: 50,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Facebook",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff472D2D),
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "qonitaarif5@gmail.com",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
