import 'package:blankpassword/credential/model/model.dart';
import 'package:credential_repository/credential_repository.dart';
import 'package:equatable/equatable.dart';

class FolderInput extends Equatable {
  const FolderInput({required this.folder});

  final Folder folder;

  FolderInput copyWith({
    int? id,
    Folder? folder,
  }) {
    return FolderInput(
      folder: folder ?? this.folder,
    );
  }

  @override
  List<Object> get props => [folder];
}
