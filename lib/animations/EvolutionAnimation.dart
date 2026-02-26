import 'package:flutter/material.dart';

/// Gère l'animation d'évolution entre deux stades de vie du dino.
///
/// L'évolution se déroule en deux phases enchaînées :
///   1. [evolveOut] — l'ancien dino disparaît en fondu sur 2.5s.
///   2. [evolveIn]  — le nouveau dino apparaît avec un effet de pop élastique sur 3.5s.
///
/// Le scale de pop part de 1.8x et revient à 1.0 via une courbe elasticOut
/// pour un effet de "surgissement" expressif.
class EvolutionAnimation {
  final TickerProvider vsync;

  /// Phase 1 : fondu de sortie de l'ancien dino (0.0 → 1.0 = opaque → transparent).
  late final AnimationController _evolveOut;

  /// Phase 2 : entrée du nouveau dino avec pop élastique (0.0 → 1.0).
  late final AnimationController _evolveIn;

  /// Courbe élastique appliquée sur [_evolveIn] pour le rebond du pop.
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

  /// Scale du nouveau dino pendant le pop d'entrée.
  /// Démarre à 1.8x et converge vers 1.0x via elasticOut.
  /// Retourne 1.0 si l'animation n'a pas encore commencé.
  double get popScale {
    if (_evolveIn.value == 0) return 1.0;
    return 1.8 - (0.8 * _evolveInCurved.value);
  }

  /// Lance la séquence complète d'évolution et attend qu'elle soit terminée.
  /// Remet les deux contrôleurs à zéro à la fin pour un prochain appel propre.
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
