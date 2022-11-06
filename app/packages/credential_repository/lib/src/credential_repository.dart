import 'models/models.dart';

enum CredentialsStatus { initial, success, failure }

abstract class CredentialRepository {
  Stream<CredentialsStatus> get status;
  Future<List<Credential>> getCredentials();
  Future<Credential> create(Credential credential);
  Future<Credential> update(Credential credential);
  Future<void> delete(Credential credential);
  Future<Credential?> get(Credential credential);
  Future<void> reload();

  void dispose();
}
