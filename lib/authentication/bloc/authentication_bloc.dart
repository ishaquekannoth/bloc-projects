import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late final StreamSubscription<AuthenticationStatus> _authStatusSubscription;
  AuthenticationBloc(this._authenticationRepository, this._userRepository)
      : super(const AuthenticationState.unknown()) {
    _authStatusSubscription =
        _authenticationRepository.getAuthStatus.listen((event) {
      add(AuthStatusChanged(authenticationStatus: event));
    });
    on<AuthStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthLogoutRequest>(_onAuthLogoutRequest);
  }
  Future<void> _onAuthenticationStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.authenticationStatus) {
      case AuthenticationStatus.unauthenticated:
        emit(const AuthenticationState.unAuthenticated());
      case AuthenticationStatus.unknown:
        emit(const AuthenticationState.unknown());
      case AuthenticationStatus.authenticated:
        final User? user = await _tryGetUser();
        if (user == null) {
          emit(const AuthenticationState.unAuthenticated());
        } else {
          emit(AuthenticationState.authenticated(user: user));
        }
    }
  }

  void _onAuthLogoutRequest(
    AuthLogoutRequest event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logout();
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }
}
