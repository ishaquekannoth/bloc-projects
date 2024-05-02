import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final StreamController<AuthenticationStatus> _controller =
      StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get getAuthStatus async* {
    await Future.delayed(Duration(seconds: 2));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> login(
      {required String userName, required String password}) async {
    await Future.delayed(Duration(seconds: 2),
        () => _controller.add(AuthenticationStatus.authenticated));
  }

  Future<void> logout() async {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
