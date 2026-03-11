import 'dart:math';
import 'package:flutter/material.dart';

class BreathAnimation {
  final TickerProvider vsync;

  late final AnimationController _breath;

  late final AnimationController _breathIntensity;

  BreathAnimation({required this.vsync}) {
    _breath = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _breathIntensity = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    );
  }

  Animation<double> get breath => _breath;
  Animation<double> get breathIntensity => _breathIntensity;

  double get breathScale {
    final intensity = _breathIntensity.value;
    final amplitude = 0.038 + intensity * 0.032;
    final baseScale = 0.962 - intensity * 0.012;
    return baseScale + amplitude * sin(_breath.value * 2 * pi);
  }

  void triggerExcitement() {
    _breathIntensity.forward(from: 0).then((_) {
      _breathIntensity.animateTo(
        0.0,
        duration: const Duration(milliseconds: 3000),
        curve: Curves.easeOut,
      );
    });
  }

  void dispose() {
    _breath.dispose();
    _breathIntensity.dispose();
  }
}
