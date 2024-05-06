part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}
final class AuthStatusChanged extends AuthenticationEvent {
  final AuthenticationStatus authenticationStatus;

  const AuthStatusChanged({required this.authenticationStatus});
}
final class AuthLogoutRequest extends AuthenticationEvent {}
