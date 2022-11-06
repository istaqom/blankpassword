import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum CredentialDeleteEvent {
  unkown,
  deleted,
}

class CredentialDeleteState extends Equatable {
  const CredentialDeleteState(this.event);
  final CredentialDeleteEvent event;

  @override
  List<Object?> get props => [event];
}

class CredentialDeleteCubit extends Cubit<CredentialDeleteState> {
  CredentialDeleteCubit()
      : super(const CredentialDeleteState(CredentialDeleteEvent.unkown));

  void deleted() => emit(
        const CredentialDeleteState(
          CredentialDeleteEvent.deleted,
        ),
      );
}
