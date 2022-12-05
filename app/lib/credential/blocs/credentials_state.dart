part of 'credentials_bloc.dart';

class CredentialsState extends Equatable {
  const CredentialsState({
    this.status = CredentialsStatus.initial,
    this.credentials = const [],
    this.folders = const [],
    this.error,
  });

  final CredentialsStatus status;
  final List<Credential> credentials;
  final List<Folder> folders;
  final String? error;

  CredentialsState copyWith({
    CredentialsStatus? status,
    List<Credential>? credentials,
    List<Folder>? folders,
    String? error,
  }) {
    return CredentialsState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
      folders: folders ?? this.folders,
      error: error,
    );
  }

  Credential? get(Credential credential) {
    for (var it in credentials) {
      if (it.id == credential.id) {
        return it;
      }
    }
    return null;
  }

  @override
  String toString() {
    return '''CredentialState { status: $status, credentials: ${credentials.length} }, folders: ${folders.length}''';
  }

  @override
  List<Object> get props => [status, credentials, folders];
}
