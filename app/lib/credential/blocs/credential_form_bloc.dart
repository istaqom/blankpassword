import 'dart:async';

import 'package:blankpassword/credential/blocs/credential_bloc.dart';
import 'package:blankpassword/credential/blocs/credentials_bloc.dart';
import 'package:blankpassword/credential/model/model.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:formz/formz.dart';

part 'credential_form_state.dart';
part 'credential_form_event.dart';

class CredentialFormRepository {
  Future<void> submit(Credential credential) async {}

  Credential convert(Credential credential) {
    return credential;
  }
}

class CredentialCreateRepository extends CredentialFormRepository {
  CredentialCreateRepository(this._credentialRepository);

  final CredentialsBloc _credentialRepository;

  @override
  Future<void> submit(Credential credential) async {
    await _credentialRepository.create(credential);
  }
}

class CredentialUpdateRepository extends CredentialFormRepository {
  CredentialUpdateRepository(
    this.repository,
  );

  final CredentialBloc repository;

  @override
  Future<void> submit(Credential credential) async {
    await repository.update(credential);
  }

  @override
  Credential convert(Credential credential) {
    return credential.copyWith(
      id: repository.state.credential.id,
    );
  }
}

class CredentialFormBloc
    extends Bloc<CredentialFormEvent, CredentialFormState> {
  CredentialFormBloc({
    required CredentialFormRepository credentialRepository,
    required this.credentialsbloc,
    CredentialFormState state = const CredentialFormState(),
  })  : _credentialRepository = credentialRepository,
        super(state) {
    on<CredentialFormDeleteSite>(_onDeleteSite);
    on<CredentialFormNewSite>(_onNewSite);
    on<CredentialFormSubmitted>(_onSubmitted);

    on<CredentialFormNameChanged>(_onNameChanged);
    on<CredentialFormUsernameChanged>(_onUsernameChanged);
    on<CredentialFormPasswordChanged>(_onPasswordChanged);
    on<CredentialFormNotesChanged>(_onNotesChanged);
    on<CredentialFormFolderChanged>(_onFolderChanged);

    on<CredentialFormSiteUrlChanged>(_onSiteUrlChanged);
  }

  final CredentialsBloc credentialsbloc;
  final CredentialFormRepository _credentialRepository;

  void removeSite(int index) {
    add(CredentialFormDeleteSite(index));
  }

  void addSite() {
    var sites = state.sites;

    var id = 1;
    try {
      id = sites[sites.length - 1].id + 1;
    } catch (e) {
      //
    }

    add(
      CredentialFormNewSite(
        SiteInput(id: id),
      ),
    );
  }

  Credential toCredential() {
    return _credentialRepository.convert(state.toCredential());
  }

  void _onDeleteSite(
    CredentialFormDeleteSite event,
    Emitter<CredentialFormState> emit,
  ) {
    emit(
      state.copyWith(
        sites: List.of(state.sites)..removeAt(event.index),
      ),
    );
  }

  void _onNewSite(
    CredentialFormNewSite event,
    Emitter<CredentialFormState> emit,
  ) {
    emit(
      state.copyWith(
        sites: List.of(state.sites)..add(event.site),
        status: FormzStatus.valid,
      ),
    );
  }

  Future<void> _onSubmitted(
    CredentialFormSubmitted event,
    Emitter<CredentialFormState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: FormzStatus.submissionInProgress),
      );

      await _credentialRepository.submit(state.toCredential());

      emit(
        state.copyWith(status: FormzStatus.submissionSuccess),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          error: e.toString(),
        ),
      );
    }
  }

  void _onNameChanged(
    CredentialFormNameChanged event,
    Emitter<CredentialFormState> emit,
  ) {
    emit(
      state.copyWith(
        name: GenericInput.dirty(event.input),
        status: FormzStatus.valid,
      ),
    );
  }

  void _onUsernameChanged(
    CredentialFormUsernameChanged event,
    Emitter<CredentialFormState> emit,
  ) {
    emit(
      state.copyWith(
        username: GenericInput.dirty(event.input),
        status: FormzStatus.valid,
      ),
    );
  }

  void _onPasswordChanged(
    CredentialFormPasswordChanged event,
    Emitter<CredentialFormState> emit,
  ) {
    emit(
      state.copyWith(
        password: GenericInput.dirty(event.input),
        status: FormzStatus.valid,
      ),
    );
  }

  void _onNotesChanged(
    CredentialFormNotesChanged event,
    Emitter<CredentialFormState> emit,
  ) {
    emit(
      state.copyWith(
        notes: GenericInput.dirty(event.input),
        status: FormzStatus.valid,
      ),
    );
  }

  void _onSiteUrlChanged(
    CredentialFormSiteUrlChanged event,
    Emitter<CredentialFormState> emit,
  ) {
    emit(
      state.copyWith(
        sites: List.of(state.sites)
          ..[event.index] = state.sites[event.index].copyWith(
            url: GenericInput.dirty(event.value),
          ),
        status: FormzStatus.valid,
      ),
    );
  }

  void _onFolderChanged(
    CredentialFormFolderChanged event,
    Emitter<CredentialFormState> emit,
  ) {
    emit(
      state.copyWith(
        folders: event.folders
            .map((it) => FolderInput(folder: it))
            .toList(growable: false),
      ),
    );
  }
}
