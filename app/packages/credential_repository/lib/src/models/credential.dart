import 'package:equatable/equatable.dart';
import 'package:user_repository/src/models/models.dart';
import './folder.dart';

class Credential extends Equatable {
  const Credential({
    this.id = '',
    this.name = '',
    this.username = '',
    this.password = '',
    this.sites = const [''],
    this.folders = const [],
    this.notes = '',
  });

  final String id;
  final String name;
  final String username;
  final String password;
  final List<String> sites;
  final List<Folder> folders;
  final String notes;

  @override
  List<Object> get props => [
        id,
        name,
        username,
        password,
        sites,
        notes,
        folders,
      ];

  Credential copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    List<String>? sites,
    List<Folder>? folders,
    String? notes,
  }) {
    return Credential(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      sites: sites ?? this.sites,
      notes: notes ?? this.notes,
      folders: folders ?? this.folders,
    );
  }
}
