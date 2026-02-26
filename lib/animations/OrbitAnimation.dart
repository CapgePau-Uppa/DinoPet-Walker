import 'dart:math';
import 'package:flutter/material.dart';

/// Gère la rotation de l'arc orbital autour du dino.
///
/// Un arc lumineux tourne en continu autour du cercle du dino,
/// comme une planète en orbite, renforçant l'aspect vivant et magique.
class OrbitAnimation {
  final TickerProvider vsync;

  /// Cycle de rotation — fait un tour complet toutes les 4s.
  late final AnimationController _orbit;

  OrbitAnimation({required this.vsync}) {
    _orbit = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  Animation<double> get orbit => _orbit;

  /// Angle courant en radians (0 → 2π) à passer au CircularArcWidget.
  double get orbitAngle => _orbit.value * 2 * pi;

  void dispose() {
    _orbit.dispose();
  }
}
