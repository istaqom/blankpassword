part of 'credential_form_bloc.dart';

abstract class CredentialFormEvent {
  const CredentialFormEvent();
}

class GenericEvent extends CredentialFormEvent {
  const GenericEvent(this.input);

  final String input;
}

class CredentialFormNameChanged extends GenericEvent {
  const CredentialFormNameChanged(super.input);
}

class CredentialFormUsernameChanged extends GenericEvent {
  const CredentialFormUsernameChanged(super.input);
}

class CredentialFormPasswordChanged extends GenericEvent {
  const CredentialFormPasswordChanged(super.input);
}

class CredentialFormNotesChanged extends GenericEvent {
  const CredentialFormNotesChanged(super.input);
}

class CredentialFormNewSite extends CredentialFormEvent {
  const CredentialFormNewSite(this.site);

  final SiteInput site;
}

class CredentialFormDeleteSite extends CredentialFormEvent {
  const CredentialFormDeleteSite(this.index);
  final int index;
}

class CredentialFormChangeSite extends CredentialFormEvent {
  const CredentialFormChangeSite(this.index, this.site);

  final int index;
  final SiteInput site;
}

class CredentialFormSubmitted extends CredentialFormEvent {}

class CredentialFormSiteEvent extends CredentialFormEvent {
  const CredentialFormSiteEvent(this.index);

  final int index;
}

class CredentialFormSiteUrlChanged extends CredentialFormSiteEvent {
  CredentialFormSiteUrlChanged(super.index, this.value);

  final String value;
}
