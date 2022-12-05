part of 'credentials_folder_bloc.dart';

abstract class CredentialsFolderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CredentialsFolderChanged extends CredentialsFolderEvent {
  CredentialsFolderChanged();
}
