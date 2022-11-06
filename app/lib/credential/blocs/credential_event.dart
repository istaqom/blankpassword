part of 'credential_bloc.dart';

abstract class CredentialEvent extends Equatable {
  const CredentialEvent();

  @override
  List<Object> get props => [];
}

class CredentialsFetched extends CredentialEvent {}

class CredentialOneEvent extends CredentialEvent {
  const CredentialOneEvent(this.credential);

  final Credential credential;

  @override
  List<Object> get props => [credential];
}

class CredentialUpdate extends CredentialOneEvent {
  const CredentialUpdate(super.credential);
}

class CredentialChanged extends CredentialOneEvent {
  const CredentialChanged(super.credential);
}

class CredentialDelete extends CredentialEvent {
  const CredentialDelete();
}
