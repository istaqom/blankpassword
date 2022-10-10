part of "authentication_bloc.dart";

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unkown,
    this.user = User.empty,
  });

  const AuthenticationState.unkown() : this._();
  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);
  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final User user;
  final AuthenticationStatus status;

  @override
  List<Object> get props => [status, user];
}
