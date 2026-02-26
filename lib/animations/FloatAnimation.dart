import 'dart:math';
import 'package:flutter/material.dart';

/// Gère l'animation de flottement vertical du dino.
///
/// Le dino monte et descend doucement en continu (±7px) sur une sinusoïde
/// pour donner une impression de légèreté, comme s'il flottait dans l'air.
class FloatAnimation {
  final TickerProvider vsync;

  /// Cycle de flottement — tourne en boucle toutes les 3.8s.
  late final AnimationController _float;

  FloatAnimation({required this.vsync}) {
    _float = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3800),
    )..repeat();
  }

  Animation<double> get float => _float;

  /// Décalage vertical en pixels à appliquer au widget.
  /// Varie entre -7px (haut) et +7px (bas) selon une sinusoïde.
  double get floatY => -7.0 * sin(_float.value * 2 * pi);

  void dispose() {
    _float.dispose();
  }
}
