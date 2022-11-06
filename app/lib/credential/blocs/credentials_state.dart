part of 'credentials_bloc.dart';

class CredentialsState extends Equatable {
  const CredentialsState({
    this.status = CredentialsStatus.initial,
    this.credentials = const [],
    this.error,
  });

  final CredentialsStatus status;
  final List<Credential> credentials;
  final String? error;

  CredentialsState copyWith({
    CredentialsStatus? status,
    List<Credential>? credentials,
    String? error,
  }) {
    return CredentialsState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
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
  List<Object> get props => [status, credentials];
}
