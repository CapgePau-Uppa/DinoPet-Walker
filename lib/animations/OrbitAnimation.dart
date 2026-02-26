import 'dart:math';
import 'package:flutter/material.dart';


class OrbitAnimation {
  final TickerProvider vsync;

  late final AnimationController _orbit;

  OrbitAnimation({required this.vsync}) {
    _orbit = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  Animation<double> get orbit => _orbit;

  double get orbitAngle => _orbit.value * 2 * pi;

  void dispose() {
    _orbit.dispose();
  }
}
