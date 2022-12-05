import 'package:equatable/equatable.dart';

class Folder extends Equatable {
  const Folder({
    this.id = '',
    this.name = '',
  });

  final String id;
  final String name;

  @override
  List<Object> get props => [id, name];

  Folder copyWith({
    String? id,
    String? name,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
