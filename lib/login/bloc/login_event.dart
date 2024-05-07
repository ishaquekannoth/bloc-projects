part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUserNameChange extends LoginEvent {
  final String userName;

  const LoginUserNameChange({required this.userName});
  @override
  List<Object> get props => [userName];
}

class LoginPasswordChange extends LoginEvent {
  final String password;

  const LoginPasswordChange({required this.password});
  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {}
