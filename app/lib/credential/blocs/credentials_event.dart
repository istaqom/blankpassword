part of 'credentials_bloc.dart';

abstract class CredentialsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CredentialsFetched extends CredentialsEvent {}

class CredentialsOneEvent extends CredentialsEvent {
  CredentialsOneEvent(this.credential);

  final Credential credential;

  @override
  List<Object> get props => [credential];
}

class CredentialsCreated extends CredentialsOneEvent {
  CredentialsCreated(super.credential);
}

class CredentialsUpdated extends CredentialsOneEvent {
  CredentialsUpdated(super.credential);
}

class CredentialsDeleted extends CredentialsOneEvent {
  CredentialsDeleted(super.credential);
}

class CredentialsError extends CredentialsEvent {
  CredentialsError(this.error);
  final String error;
}

class CredentialsStatusChanged extends CredentialsEvent {
  CredentialsStatusChanged(this.status);

  final CredentialsStatus status;
}
