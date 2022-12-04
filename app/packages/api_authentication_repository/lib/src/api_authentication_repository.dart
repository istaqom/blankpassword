import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/models.dart';

class ApiAuthenticationInterceptor implements InterceptorContract {
  String? session = null;

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    if (session != null) {
      data.headers.putIfAbsent("Authorization", () => "Bearer $session");
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ApiAuthenticationRepository extends AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final http.Client client;
  final String url;
  final ApiAuthenticationInterceptor interceptor;
  ApiAuthenticationRepository({
    required this.client,
    required this.url,
    required this.interceptor,
  });

  @override
  void dispose() {
    _controller.close();
    client.close();
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var response = await client.post(
        Uri.http(url, 'api/v1/auth/login'),
        body: json.encode({'email': email, 'password': password}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      return handleAuth(response);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      var response = await client.post(
        Uri.http(url, 'api/v1/auth/register'),
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      return handleAuth(response);
    } catch (e) {
      throw e;
    }
  }

  void handleAuth(http.Response response) {
    var body = handleResponse(response);

    interceptor.session = body['data']['session'];
    _controller.add(AuthenticationStatus.authenticated);
  }

  Map<dynamic, dynamic> handleResponse(http.Response response) {
    Map<dynamic, dynamic> body = json.decode(response.body);
    if (body["status"] == "error") {
      if (body.containsKey("message")) {
        throw body['message'];
      }
      throw response.body;
    }

    return body;
  }

  @override
  Future<void> logOut() async {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  @override
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }
}
