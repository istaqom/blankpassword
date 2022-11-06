import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:credential_repository/credential_repository.dart';

part 'credentials_event.dart';
part 'credentials_state.dart';

class CredentialsBloc extends Bloc<CredentialsEvent, CredentialsState> {
  CredentialsBloc({
    required CredentialRepository credentialRepository,
  })  : _credentialRepository = credentialRepository,
        super(const CredentialsState()) {
    on<CredentialsStatusChanged>(_onCredentialStatusChanged);
    on<CredentialsFetched>(_onCredentialFetched);
    on<CredentialsCreated>(_onCredentialCreated);
    on<CredentialsUpdated>(_onCredentialUpdated);
    on<CredentialsDeleted>(_onCredentialDeleted);

    _credentialSubscribtion = _credentialRepository.status
        .listen((status) => add(CredentialsStatusChanged(status)));
  }

  late StreamSubscription<CredentialsStatus> _credentialSubscribtion;
  final CredentialRepository _credentialRepository;

  void loadCredential() {
    add(CredentialsFetched());
  }

  Future<void> _onCredentialFetched(
    CredentialsFetched event,
    Emitter<CredentialsState> emit,
  ) async {
    try {
      var credentials = await _credentialRepository.getCredentials();

      emit(state.copyWith(credentials: credentials));
    } catch (e) {
      emit(
        state.copyWith(
          status: CredentialsStatus.failure,
          error: e.toString(),
        ),
      );
      // TODO: report error
    }
  }

  Future<void> create(Credential credential) async {
    try {
      credential = await _credentialRepository.create(credential);

      add(CredentialsCreated(credential));
    } catch (e) {
      // emit(state.copyWith())
    }
  }

  Future<void> update(Credential credential) async {
    try {
      credential = await _credentialRepository.update(credential);

      add(CredentialsUpdated(credential));
    } catch (e) {
      print(e);
    }
  }

  Future<void> reload() async {
    add(CredentialsFetched());
    await stream.first;
  }

  Future<void> delete(Credential credential) async {
    try {
      await _credentialRepository.delete(credential);

      add(CredentialsDeleted(credential));
    } catch (e) {}
  }

  Future<Credential?> get(Credential credential) async {
    return await _credentialRepository.get(credential);
  }

  Future<void> _onCredentialCreated(
    CredentialsCreated event,
    Emitter<CredentialsState> emit,
  ) async {
    var credentials = await _credentialRepository.getCredentials();

    emit(state.copyWith(credentials: credentials));
  }

  Future<void> _onCredentialUpdated(
    CredentialsUpdated event,
    Emitter<CredentialsState> emit,
  ) async {
    emit(
      state.copyWith(
        credentials: await _credentialRepository.getCredentials(),
      ),
    );
  }

  Future<void> _onCredentialDeleted(
    CredentialsDeleted event,
    Emitter<CredentialsState> emit,
  ) async {
    emit(
      state.copyWith(
        credentials: await _credentialRepository.getCredentials(),
      ),
    );
  }

  Future<void> _onCredentialStatusChanged(
    CredentialsStatusChanged event,
    Emitter<CredentialsState> emit,
  ) async {
    emit(state.copyWith(status: event.status));
  }

  @override
  Future<void> close() {
    _credentialSubscribtion.cancel();
    _credentialRepository.dispose();
    return super.close();
  }
}
