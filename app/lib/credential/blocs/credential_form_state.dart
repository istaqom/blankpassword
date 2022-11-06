part of 'credential_form_bloc.dart';

class CredentialFormState extends Equatable {
  const CredentialFormState({
    this.name = const GenericInput.pure(),
    this.username = const GenericInput.pure(),
    this.password = const GenericInput.pure(),
    this.notes = const GenericInput.pure(),
    this.sites = const [SiteInput(id: 1)],
    this.status = FormzStatus.pure,
    this.error,
  });

  factory CredentialFormState.fromCredential(Credential credential) {
    return CredentialFormState(
      name: GenericInput.dirty(credential.name),
      username: GenericInput.dirty(credential.username),
      password: GenericInput.dirty(credential.password),
      notes: GenericInput.dirty(credential.notes),
      sites: credential.sites
          .mapIndexed(
            (index, site) => SiteInput(
              id: index,
              url: GenericInput.dirty(site),
            ),
          )
          .toList(),
    );
  }

  final GenericInput name;
  final GenericInput username;
  final GenericInput password;
  final GenericInput notes;
  final List<SiteInput> sites;
  final FormzStatus status;
  final String? error;

  @override
  String toString() {
    return '''CredentialFormState { name: $name, username: $username, password: $password, notes: $notes }''';
  }

  CredentialFormState copyWith({
    GenericInput? name,
    GenericInput? username,
    GenericInput? password,
    GenericInput? notes,
    List<SiteInput>? sites,
    FormzStatus? status,
    String? error,
  }) {
    return CredentialFormState(
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      notes: notes ?? this.notes,
      sites: sites ?? this.sites,
      status: status ?? this.status,
      error: error,
    );
  }

  Credential toCredential() {
    return Credential(
      name: name.value,
      username: username.value,
      password: password.value,
      notes: notes.value,
      sites: sites
          .map(
            (it) => it.url.value,
          )
          .toList(),
    );
  }

  @override
  List<Object> get props => [name, username, password, notes, sites, status];
}
