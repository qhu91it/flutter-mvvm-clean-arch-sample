import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../foundation/helper/helper.dart';

class CounterState {
  final int count1;
  final int count2;

  const CounterState({this.count1 = 0, this.count2 = 0});
}

class CounterViewModel extends StateNotifier<CounterState> {
  CounterViewModel() : super(const CounterState());

  void increment() {
    state = CounterState(
      count1: state.count1 + 1,
      count2: state.count2,
    );
  }

  void increment2() {
    state = CounterState(
      count1: state.count1,
      count2: state.count2 + 1,
    );
  }

  Color randomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }

  @override
  void dispose() {
    logD('Dispose $runtimeType');
    super.dispose();
  }
}

final counterViewModelProvider =
    StateNotifierProvider.autoDispose<CounterViewModel, CounterState>((ref) {
  return CounterViewModel();
});
