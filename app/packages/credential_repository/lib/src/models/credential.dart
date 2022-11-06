import 'package:equatable/equatable.dart';

class Credential extends Equatable {
  const Credential({
    this.id = '',
    this.name = '',
    this.username = '',
    this.password = '',
    this.sites = const [''],
    this.notes = '',
  });

  final String id;
  final String name;
  final String username;
  final String password;
  final List<String> sites;
  final String notes;

  @override
  List<Object> get props => [id, name, username, password, sites, notes];

  Credential copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    List<String>? sites,
    String? notes,
  }) {
    return Credential(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      sites: sites ?? this.sites,
      notes: notes ?? this.notes,
    );
  }
}
