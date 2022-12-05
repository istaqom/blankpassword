import 'package:cached_network_image/cached_network_image.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:flutter/material.dart';

class CredentialListWidget extends StatelessWidget {
  const CredentialListWidget({
    super.key,
    required this.credentials,
    required this.onCredentialPressed,
  });

  final List<Credential> credentials;
  final void Function(Credential) onCredentialPressed;

  String getFavicon(Credential item) {
    for (var it in item.sites) {
      try {
        var uri = Uri.parse(it);
        if (uri.hasScheme) {
          return "${uri.host}/favicon.ico";
        } else {
          return "${Uri(scheme: "https", host: it)}/favicon.ico";
        }
      } catch (e) {}
    }

    return "localhost";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var item in credentials)
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
                  CachedNetworkImage(
                    imageUrl: getFavicon(item),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.web,
                      color: Color(0xff472D2D),
                    ),
                    height: 50,
                    width: 50,
                  ),
                  const Padding(padding: EdgeInsets.all(4)),
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
