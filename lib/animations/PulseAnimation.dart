import 'dart:math';
import 'package:flutter/material.dart';

/// Gère la pulsation du halo lumineux (glow) sous le dino.
///
/// Le halo augmente et diminue en intensité de façon cyclique,
/// comme un battement de cœur lumineux autour du cercle du dino.
class PulseAnimation {
  final TickerProvider vsync;

  /// Cycle de pulsation — tourne en boucle toutes les 2s.
  late final AnimationController _pulse;

  PulseAnimation({required this.vsync}) {
    _pulse = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  Animation<double> get pulse => _pulse;

  /// Intensité du glow à utiliser dans le blurRadius de la BoxShadow.
  /// Varie entre 0.12 (minimum) et 0.34 (maximum).
  double get pulseGlow => 0.12 + 0.22 * sin(_pulse.value * 2 * pi);

  void dispose() {
    _pulse.dispose();
  }
}
