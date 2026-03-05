import 'dart:math';
import 'package:flutter/material.dart';

class FloatAnimation {
  final TickerProvider vsync;

  late final AnimationController _float;

  FloatAnimation({required this.vsync}) {
    _float = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3800),
    )..repeat();
  }

  Animation<double> get float => _float;

  double get floatY => -7.0 * sin(_float.value * 2 * pi);

  void dispose() {
    _float.dispose();
  }
}
