import 'package:flutter/material.dart';

class EvolutionAnimation {
  final TickerProvider vsync;

  late final AnimationController _evolveOut;


  late final AnimationController _evolveIn;

  late final CurvedAnimation _evolveInCurved;

  EvolutionAnimation({required this.vsync}) {
    _evolveOut = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2500),
    );

    _evolveIn = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3500),
    );

    _evolveInCurved = CurvedAnimation(
      parent: _evolveIn,
      curve: Curves.elasticOut,
    );
  }

  Animation<double> get evolveOut => _evolveOut;
  Animation<double> get evolveIn => _evolveIn;
  Animation<double> get evolveInCurved => _evolveInCurved;

  double get popScale {
    if (_evolveIn.value == 0) return 1.0;
    return 1.8 - (0.8 * _evolveInCurved.value);
  }

  Future<void> triggerEvolution() async {
    await _evolveOut.forward(from: 0);
    await _evolveIn.forward(from: 0);
    _evolveOut.reset();
    _evolveIn.reset();
  }

  void dispose() {
    _evolveOut.dispose();
    _evolveIn.dispose();
    _evolveInCurved.dispose();
  }
}
