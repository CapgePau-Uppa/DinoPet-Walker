import 'package:flutter/material.dart';

class StarParticleAnimation {
  final TickerProvider vsync;

  late final AnimationController _starParticle;

  StarParticleAnimation({required this.vsync}) {
    _starParticle = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  Animation<double> get starParticle => _starParticle;

  double get progress => _starParticle.value;

  void dispose() {
    _starParticle.dispose();
  }
}
