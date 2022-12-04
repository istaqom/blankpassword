import 'package:blankpassword/credential/blocs/credential_bloc.dart';
import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:blankpassword/credential/view/credential_widget.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:flutter/material.dart';

class CredentialListWidget extends StatelessWidget {
  const CredentialListWidget({
    super.key,
    required this.bloc,
    required this.onCredentialPressed,
  });

  final CredentialsBloc bloc;
  final void Function(Credential) onCredentialPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var item in bloc.state.credentials)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              onPressed: () {
                onCredentialPressed(item);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.web,
                    color: Color(0xff472D2D),
                    size: 50,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xff472D2D),
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          item.username,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
