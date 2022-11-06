part of 'credential_bloc.dart';

enum CredentialStatus { unkown, deleted }

class CredentialState extends Equatable {
  const CredentialState(
      {required this.credential, this.status = CredentialStatus.unkown});

  final Credential credential;
  final CredentialStatus status;

  CredentialState copyWith({
    Credential? credential,
    CredentialStatus? status,
  }) {
    return CredentialState(
      credential: credential ?? this.credential,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [credential];
}
