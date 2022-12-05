import 'package:blankpassword/credential/model/model.dart';
import 'package:equatable/equatable.dart';

class SiteInput extends Equatable {
  const SiteInput({
    this.id = 0,
    this.url = const GenericInput.pure(),
  });

  final int id;
  final GenericInput url;

  SiteInput copyWith({
    int? id,
    GenericInput? url,
  }) {
    return SiteInput(
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }

  @override
  List<Object> get props => [id, url];
}
