import 'package:api_credential_repository/api_credential_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

class AuthenticationRepositoryAdapter extends AuthenticationRepository {
  AuthenticationRepositoryAdapter({
    required this.authentication,
    required this.credential,
  });

  final AuthenticationRepository authentication;
  final ApiCredentialRepository credential;

  @override
  void dispose() {
    authentication.dispose();
  }

  @override
  Future<void> logOut() {
    return authentication.logOut();
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await authentication.signIn(email: email, password: password);
    credential.password = password;
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await authentication.signUp(email: email, password: password);
    credential.password = password;
  }

  @override
  Stream<AuthenticationStatus> get status => authentication.status;
}
