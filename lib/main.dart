import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
              body: Center(
        child: Container(
          color: Colors.greenAccent,
          child: const Text("This is the centre"),
        ),
      ))),
    );
  }
}
