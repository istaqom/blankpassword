part of 'credentials_folder_bloc.dart';

class CredentialsFolderState extends Equatable {
  const CredentialsFolderState({
    required this.folder,
    this.status = CredentialsStatus.initial,
    this.credentials = const [],
    this.error,
  });

  final CredentialsStatus status;
  final List<Credential> credentials;
  final Folder folder;
  final String? error;

  CredentialsFolderState copyWith({
    CredentialsStatus? status,
    List<Credential>? credentials,
    Folder? folder,
    String? error,
  }) {
    return CredentialsFolderState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
      folder: folder ?? this.folder,
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
    return '''CredentialState { status: $status, credentials: ${credentials.length} }''';
  }

  @override
  List<Object> get props => [status, credentials, folder];
}
