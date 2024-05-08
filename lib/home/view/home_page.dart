import 'package:blocprojects/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                final userId = context.select<AuthenticationBloc, String>(
                    (bloc) => bloc.state.user.id);
                return Text(userId);
              },
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(AuthLogoutRequest());
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}
