import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:crypto/crypto.dart';
import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;

Future<Encrypter> createEncrypter(
  String? password,
  String salt,
) async {
  var s = Salt(utf8.encode(salt));

  var result = await argon2.hashPasswordString(
    "$salt-$password",
    salt: s,
  );

  var stringKey = sha256.convert(result.rawBytes).toString();
  var key = Key.fromBase16(stringKey);

  return Encrypter(AES(key));
}

Future<String> credentialToJson(String? password, Credential credential) async {
  var data = {
    "username": credential.username,
    "password": credential.password,
    "notes": credential.notes,
    "sites": credential.sites.map((it) {
      return {"url": it};
    }).toList()
  };

  var salt = sha256.convert(utf8.encode(credential.name)).toString();
  var encrypter = await createEncrypter(password, salt);

  var iv = IV.fromSecureRandom(16);

  var jsonData = jsonEncode(data);
  var d = encrypter.encrypt(jsonData, iv: iv);

  return jsonEncode({
    "name": credential.name,
    "data": {
      'salt': salt,
      "encrypted": d.base64,
      "iv": iv.base64,
      "v": 1,
    }
  });
}

Credential credentialFromEncrypted({
  String? id,
  required String name,
  required dynamic data,
}) {
  List<dynamic> sites = data['sites'];

  return Credential(
    id: id ?? '',
    name: name,
    username: data['username'],
    password: data['password'],
    notes: data['notes'],
    sites: sites.map((it) => it['url'] as String).toList(),
  );
}

Future<Credential> credentialFromJson(
  String? password,
  dynamic credential,
) async {
  Map<dynamic, dynamic> json = credential;

  var encrypter = await createEncrypter(password, json['data']['salt']);

  var dataString = encrypter.decrypt64(
    json['data']['encrypted'],
    iv: IV.fromBase64(json['data']['iv']),
  );

  var data = jsonDecode(dataString);

  return credentialFromEncrypted(
    id: json['id'],
    name: json['name'],
    data: data,
  );
}

class ApiCredentialRepository extends CredentialRepository {
  final _controller = StreamController<CredentialsStatus>();
  final http.Client client;
  final String url;
  final List<Credential> credentials = [];

  String? password = null;

  ApiCredentialRepository({
    required this.client,
    required this.url,
  });

  @override
  void dispose() {
    _controller.close();
    client.close();
  }

  @override
  Future<List<Credential>> getCredentials() async {
    if (this.credentials.isEmpty) {
      await reload();
    }

    return this.credentials.toList();
  }

  int? _getIndex(Credential credential) {
    for (var index = 0; index < this.credentials.length; ++index) {
      if (this.credentials[index].id == credential.id) {
        return index;
      }
    }
    return null;
  }

  @override
  Future<Credential> create(Credential credential) async {
    var response = await client.post(
      Uri.http(url, 'api/v1/credential'),
      body: await credentialToJson(password, credential),
      headers: {
        "Content-Type": "application/json",
      },
    );

    var json = handleResponse(response);

    var c = credential.copyWith(id: json['data']['uuid']);
    this.credentials.add(c);

    return c;
  }

  @override
  Future<Credential> update(Credential credential) async {
    var response = await client.put(
      Uri.http(
        url,
        'api/v1/credential/${credential.id}',
      ),
      body: await credentialToJson(password, credential),
      headers: {
        "Content-Type": "application/json",
      },
    );

    handleResponse(response);

    var index = _getIndex(credential);
    if (index != null) {
      credentials[index] = credential;
    }

    return credential;
  }

  @override
  Future<void> reload() async {
    var response = await client.get(Uri.http(url, 'api/v1/credential'));

    var json = handleResponse(response);

    List<dynamic> credentials = json['data'];
    this.credentials.clear();
    this.credentials.addAll(
          await Future.wait(credentials.map(
            (it) => credentialFromJson(password, it),
          )),
        );
  }

  @override
  Future<void> delete(Credential credential) async {
    var response = await client.delete(
      Uri.http(
        url,
        'api/v1/credential/${credential.id}',
      ),
    );

    handleResponse(response);

    var index = _getIndex(credential);
    if (index != null) {
      credentials.removeAt(index);
    }
  }

  @override
  Future<Credential?> get(Credential credential) async {
    var index = _getIndex(credential);

    if (index != null) {
      return credentials[index];
    } else {
      return null;
    }
  }

  Map<dynamic, dynamic> handleResponse(http.Response response) {
    Map<dynamic, dynamic> body = json.decode(response.body);

    if (body.containsKey('message')) {
      throw body['message'];
    }

    return body;
  }

  @override
  Stream<CredentialsStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield* _controller.stream;
  }
}
