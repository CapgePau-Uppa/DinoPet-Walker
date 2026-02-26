import 'dart:math';
import 'package:flutter/material.dart';


class PulseAnimation {
  final TickerProvider vsync;

  late final AnimationController _pulse;

  PulseAnimation({required this.vsync}) {
    _pulse = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  Animation<double> get pulse => _pulse;

  double get pulseGlow => 0.12 + 0.22 * sin(_pulse.value * 2 * pi);

  void dispose() {
    _pulse.dispose();
  }
}
