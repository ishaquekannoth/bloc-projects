import 'dart:async';

import 'package:blocprojects/ticker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 60;
  final Ticker _ticker;
  StreamSubscription<int>? tickerSubscription;
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(duration: _duration)) {
    on<TimerStarted>(_onStart);
    on<_TimerTicked>(_onTimerTicked);
    on<TimerPaused>(_onPause);
    on<TimerResumed>(_onResume);
    on<TimerReset>(_onReset);
  }

  @override
  Future<void> close() {
    tickerSubscription?.cancel();

    return super.close();
  }

  void _onStart(TimerStarted event, Emitter<TimerState> emit) {
    emit(const TimerRunInProgress(duration: _duration));
    tickerSubscription?.cancel();
    tickerSubscription = _ticker.tick(ticks: event.duration).listen((duration) {
      add(_TimerTicked(duration: duration));
    });
  }

  void _onTimerTicked(_TimerTicked event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      emit(TimerRunInProgress(duration: event.duration));
    } else {
      emit(const TimerRunComplete());
    }
  }

  void _onPause(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      tickerSubscription?.pause;
      emit(TimerRunPause(duration: state.duration));
    }
  }

  void _onResume(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      tickerSubscription?.resume();
      emit(TimerRunInProgress(duration: state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    tickerSubscription?.cancel();
    emit(const TimerInitial(duration: _duration));
  }
}
