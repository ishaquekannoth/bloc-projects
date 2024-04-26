import 'package:bloc/bloc.dart';
import 'package:blocprojects/app.dart';
import 'package:blocprojects/simple_bloc_observer.dart';
import 'package:flutter/material.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(const MyApp());
}
