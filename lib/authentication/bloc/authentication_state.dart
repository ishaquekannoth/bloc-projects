part of 'authentication_bloc.dart';

 final class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.authenticationStatus = AuthenticationStatus.unknown,
    this.user = User.empty,
  });

  final AuthenticationStatus authenticationStatus;
  final User user;
  @override
  List<Object> get props => [user, authenticationStatus];
  const AuthenticationState.unknown() : this._();
  const AuthenticationState.authenticated({required User user})
      : this._(
            authenticationStatus: AuthenticationStatus.authenticated,
            user: user);

  const AuthenticationState.unAuthenticated()
      : this._(
          authenticationStatus: AuthenticationStatus.unauthenticated,
        );
}
