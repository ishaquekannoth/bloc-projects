import 'package:authentication_repository/authentication_repository.dart';
import 'package:blocprojects/authentication/bloc/authentication_bloc.dart';
import 'package:blocprojects/home/view/home_page.dart';
import 'package:blocprojects/login/view/login_page.dart';
import 'package:blocprojects/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthenticationRepository authenticationRepository;
  late final UserRepository userRepository;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: authenticationRepository,
        child: BlocProvider(
          create: (context) =>
              AuthenticationBloc(authenticationRepository, userRepository),
          child: const AppView(),
        ));
  }

  @override
  void initState() {
    authenticationRepository = AuthenticationRepository();
    userRepository = UserRepository();
    super.initState();
  }

  @override
  void dispose() {
    authenticationRepository.dispose();
    super.dispose();
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.authenticationStatus) {
              case AuthenticationStatus.unknown:
                break;
              case AuthenticationStatus.authenticated:
                navigator.pushAndRemoveUntil<void>(
                    HomePage.route(), (route) => false);
              case AuthenticationStatus.unauthenticated:
                navigator.pushAndRemoveUntil<void>(
                    LoginPage.route(), (route) => false);
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (settings) => SplashPage.route(),
    );
  }
}
