import 'dart:async';

enum AuthenticationStatus { unkown, authenticated, unauthenticated }

abstract class AuthenticationRepository {
  const AuthenticationRepository();
  Stream<AuthenticationStatus> get status;
  Future<void> signIn({required String email, required String password});
  Future<void> signUp({required String email, required String password});
  Future<void> logOut();
  void dispose();
}
