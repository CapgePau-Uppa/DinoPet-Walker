import 'dart:math';
import 'package:flutter/material.dart';

/// Gère l'animation de respiration du dino.
///
/// Le dino effectue un léger scale up/down en continu pour simuler
/// une respiration vivante. L'intensité peut être boostée temporairement
/// (ex: quand le dino est excité après une interaction).
class BreathAnimation {
  final TickerProvider vsync;

  /// Cycle de respiration de base — tourne en boucle toutes les 2.8s.
  late final AnimationController _breath;

  /// Multiplicateur d'intensité de la respiration (0.0 → 1.0).
  /// Monte rapidement puis redescend doucement lors d'un événement d'excitation.
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

  /// Scale calculé à partir du souffle et de son intensité courante.
  /// Plus l'intensité est haute, plus l'amplitude et la compression sont grandes.
  double get breathScale {
    final intensity = _breathIntensity.value;
    final amplitude = 0.038 + intensity * 0.032;
    final baseScale = 0.962 - intensity * 0.012;
    return baseScale + amplitude * sin(_breath.value * 2 * pi);
  }

  /// Déclenche un pic d'intensité de respiration puis redescend progressivement.
  /// Appelé quand le dino reçoit de la nourriture, des soins, etc.
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
