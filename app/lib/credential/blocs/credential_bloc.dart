import 'dart:async';

import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'credential_state.dart';
part 'credential_event.dart';

class CredentialBloc extends Bloc<CredentialEvent, CredentialState> {
  CredentialBloc({required this.credentialBloc, required Credential credential})
      : super(
          CredentialState(
            credential: credential,
          ),
        ) {
    on<CredentialUpdate>(_onUpdate);
    on<CredentialChanged>(_onChanged);
    on<CredentialDelete>(_onDelete);

    _credentialBlocStream = credentialBloc.stream.listen((event) {
      var credential = event.get(state.credential);
      if (credential != null && credential != state.credential) {
        add(CredentialChanged(credential));
      }
    });
  }

  late StreamSubscription<CredentialsState> _credentialBlocStream;
  final CredentialsBloc credentialBloc;

  Future<void> update(Credential c) async {
    var credential = c.copyWith(id: state.credential.id);
    await credentialBloc.update(credential);
    add(CredentialChanged(credential));
  }

  void delete() {
    add(const CredentialDelete());
  }

  Future<void> _onUpdate(
    CredentialUpdate event,
    Emitter<CredentialState> emit,
  ) async {
    await _onChanged(CredentialChanged(event.credential), emit);
  }

  Future<void> _onDelete(
    CredentialDelete event,
    Emitter<CredentialState> emit,
  ) async {
    await credentialBloc.delete(state.credential);
    emit(state.copyWith(status: CredentialStatus.deleted));
  }

  Future<void> _onChanged(
    CredentialChanged event,
    Emitter<CredentialState> emit,
  ) async {
    emit(
      state.copyWith(
        credential: event.credential,
      ),
    );
  }

  @override
  Future<void> close() async {
    super.close();
    _credentialBlocStream.cancel();
  }
}
