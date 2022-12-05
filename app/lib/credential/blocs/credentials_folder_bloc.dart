import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'credentials_folder_event.dart';
part 'credentials_folder_state.dart';

List<Credential> credentialsBlocList(CredentialsBloc bloc, Folder folder) {
  return bloc.state.credentials.where(
    (element) {
      return element.folders.where((it) => it.id == folder.id).isNotEmpty;
    },
  ).toList(growable: false);
}

class CredentialsFolderBloc
    extends Bloc<CredentialsFolderEvent, CredentialsFolderState> {
  CredentialsFolderBloc({required this.credentialsBloc, required Folder folder})
      : super(
          CredentialsFolderState(
            folder: folder,
            credentials: credentialsBlocList(credentialsBloc, folder),
          ),
        ) {
    on<CredentialsFolderChanged>(_onCredentialsChanged);

    credentialsBloc.stream.listen((event) {
      add(CredentialsFolderChanged());
    });
  }

  Future<void> reload() async {
    await credentialsBloc.reload();
  }

  Future<void> create(Credential credential) async {
    await credentialsBloc.create(credential);
  }

  Future<void> update(Credential credential) async {
    await credentialsBloc.update(credential);
  }

  Future<void> delete(Credential credential) async {
    await credentialsBloc.delete(credential);
  }

  CredentialsFolderState _sync() {
    var it = state.copyWith(
      credentials: credentialsBlocList(credentialsBloc, state.folder),
    );

    return it;
  }

  Future<void> _onCredentialsChanged(
    CredentialsFolderChanged event,
    Emitter<CredentialsFolderState> emit,
  ) async {
    emit(_sync());
  }

  final CredentialsBloc credentialsBloc;
}
