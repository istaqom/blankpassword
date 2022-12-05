import 'package:blankpassword/credential/model/sites.dart';
import 'package:blankpassword/generate_password.dart';
import 'package:blankpassword/widget/password_field.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../blocs/credential_form_bloc.dart';
import 'package:flutter/material.dart';

class Shared {
  const Shared({
    required this.readOnly,
    required this.bloc,
  });
  final bool readOnly;
  final CredentialFormBloc bloc;
}

class CredentialInputWidget extends StatefulWidget {
  const CredentialInputWidget({
    super.key,
    required this.bloc,
    this.readOnly = false,
  });

  final CredentialFormBloc bloc;
  final bool readOnly;

  @override
  State<CredentialInputWidget> createState() => _CredentialInputWidgetState();
}

class _CredentialInputWidgetState extends State<CredentialInputWidget> {
  @override
  Widget build(BuildContext context) {
    var shared = Shared(
      bloc: widget.bloc,
      readOnly: widget.readOnly,
    );
    return Column(
      children: [
        NameInput(shared),
        UsernameInput(shared),
        PasswordInput(shared),
        SitesInputWidget(shared),
        NoteInput(shared),
        FoldersInput(shared),
      ],
    );
  }
}

class NameInput extends StatelessWidget {
  const NameInput(this.shared, {super.key});

  final Shared shared;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialFormBloc, CredentialFormState>(
      bloc: shared.bloc,
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            key: const Key("credentialForm_nameInput_textField"),
            initialValue: state.name.value,
            onChanged: (value) {
              shared.bloc.add(CredentialFormNameChanged(value));
            },
            readOnly: shared.readOnly,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.web),
              labelText: "Nama",
              filled: true,
              fillColor: Colors.white,
              hintText: "Nama",
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        );
      },
    );
  }
}

class UsernameInput extends StatelessWidget {
  const UsernameInput(this.shared, {super.key});
  final Shared shared;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialFormBloc, CredentialFormState>(
      bloc: shared.bloc,
      buildWhen: ((previous, current) => previous.username != current.username),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            key: const Key("credentialForm_usernameInput_textField"),
            initialValue: state.username.value,
            onChanged: (value) {
              shared.bloc.add(CredentialFormUsernameChanged(value));
            },
            readOnly: shared.readOnly,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: "Username",
              filled: true,
              fillColor: Colors.white,
              hintText: "Username",
              hintStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput(this.shared, {super.key});
  final Shared shared;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.text = widget.shared.bloc.state.password.value;
    if (controller.text.isEmpty) {
      var password = generatePassword(GeneratePasswordOption());
      controller.text = password;
      widget.shared.bloc.add(CredentialFormPasswordChanged(password));
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialFormBloc, CredentialFormState>(
      bloc: widget.shared.bloc,
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: PasswordField(
            labelText: "Password",
            controller: controller,
            onChanged: (value) {
              widget.shared.bloc.add(CredentialFormPasswordChanged(value));
            },
            readOnly: widget.shared.readOnly,
            suffixIcon: [
              if (!widget.shared.readOnly)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    final String? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeneratePasswordWidget(),
                      ),
                    );

                    if (!mounted) return;
                    // ignore if null
                    if (result == null) return;

                    setState(
                      () {
                        controller.text = result;
                      },
                    );
                  },
                ),
              // !readOnly
            ],
          ),
        );
      },
    );
  }
}

class SitesInputWidget extends StatelessWidget {
  const SitesInputWidget(this.shared, {super.key});
  final Shared shared;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialFormBloc, CredentialFormState>(
        bloc: shared.bloc,
        buildWhen: ((previous, current) => previous.sites != current.sites),
        builder: (context, state) {
          var sites = state.sites;

          return Column(
            children: [
              for (var i = 0; i < sites.length; ++i)
                SiteInputWidget(
                  key: ObjectKey(sites[i].id),
                  shared,
                  index: i,
                  site: sites[i],
                ),
              if (!shared.readOnly)
                TextButton(
                  child: const Text(
                    "New Site",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    shared.bloc.addSite();
                  },
                ),
            ],
          );
        });
  }
}

class SiteInputWidget extends StatefulWidget {
  const SiteInputWidget(
    this.shared, {
    super.key,
    required this.index,
    required this.site,
  });

  final Shared shared;
  final int index;
  final SiteInput site;

  @override
  State<SiteInputWidget> createState() => _SiteInputWidgetState();
}

class _SiteInputWidgetState extends State<SiteInputWidget> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.text = widget.site.url.value;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var i = widget.index;
    var shared = widget.shared;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        readOnly: shared.readOnly,
        onChanged: (value) {
          shared.bloc.add(
            CredentialFormSiteUrlChanged(
              i,
              value,
            ),
          );
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.web),
          hintText: "URL ${i + 1}",
          hintStyle: TextStyle(color: Theme.of(context).primaryColor),
          labelText: "URL ${i + 1}",
          filled: true,
          fillColor: Colors.white,
          suffixIcon: shared.readOnly
              ? null
              : IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    shared.bloc.removeSite(i);
                  },
                ),
        ),
      ),
    );
  }
}

class NoteInput extends StatelessWidget {
  const NoteInput(this.shared, {super.key});
  final Shared shared;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialFormBloc, CredentialFormState>(
      bloc: shared.bloc,
      buildWhen: (previous, current) => previous.notes != current.notes,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            key: const Key("credentialForm_notesInput_textField"),
            initialValue: state.notes.value,
            readOnly: shared.readOnly,
            onChanged: (value) {
              shared.bloc.add(CredentialFormNotesChanged(value));
            },
            decoration: InputDecoration(
              labelText: "Notes",
              filled: true,
              fillColor: Colors.white,
              hintText: "Notes",
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            minLines: 4,
            maxLines: null,
          ),
        );
      },
    );
  }
}

class FoldersInput extends StatelessWidget {
  const FoldersInput(this.shared, {super.key});
  final Shared shared;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialFormBloc, CredentialFormState>(
      bloc: shared.bloc,
      buildWhen: (previous, current) => previous.folders != current.folders,
      builder: (context, state) {
        return Container(
          height: 200,
          child: MultiSelectDialogField<Folder>(
            items: shared.bloc.credentialsbloc.state.folders.map((element) {
              return MultiSelectItem(element, element.name);
            }).toList(growable: false),
            onConfirm: (list) {
              shared.bloc.add(CredentialFormFolderChanged(list));
            },
            initialValue: shared.bloc.state.folders
                .map(
                  (it) => it.folder,
                )
                .toList(
                  growable: false,
                ),
          ),
        );
      },
    );
  }
}
