import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:credential_repository/credential_repository.dart';
import 'package:http/http.dart' as http;

String credentialToJson(Credential credential) {
  return jsonEncode({
    "name": credential.name,
    "data": {
      "username": credential.username,
      "password": credential.password,
      "notes": credential.notes,
      "sites": credential.sites.map((it) {
        return {"url": it};
      }).toList()
    }
  });
}

Credential credentialFromJson(dynamic credential) {
  Map<dynamic, dynamic> json = credential;

  Map<dynamic, dynamic> data = json['data'];

  List<dynamic> sites = data['sites'];

  return Credential(
    id: json['id'] ?? '',
    name: json['name'],
    username: data['username'],
    password: data['password'],
    notes: data['notes'],
    sites: sites.map((it) => it['url'] as String).toList(),
  );
}

class ApiCredentialRepository extends CredentialRepository {
  final _controller = StreamController<CredentialsStatus>();
  final http.Client client;
  final String url;
  final List<Credential> credentials = [];

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
      body: credentialToJson(credential),
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
      body: credentialToJson(credential),
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
    this.credentials.addAll(credentials.map((it) => credentialFromJson(it)));
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
