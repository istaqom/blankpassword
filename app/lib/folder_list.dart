import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:flutter/material.dart';

class FolderListWidget extends StatelessWidget {
  const FolderListWidget({
    super.key,
    required this.folders,
    required this.onFolderPressed,
  });

  final List<Folder> folders;
  final void Function(Folder) onFolderPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var item in folders)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                color: Colors.transparent,
              )),
              onPressed: () {
                onFolderPressed(item);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => YourPasswordFolderWidget(
                //       bloc: widget.bloc,
                //       credentialRepository: widget.credentialRepository,
                //     ),
                //   ),
                // );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.folder,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
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
