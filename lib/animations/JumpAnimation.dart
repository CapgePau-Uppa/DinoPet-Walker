import 'dart:math';
import 'package:flutter/material.dart';

/// Gère les sauts idle aléatoires du dino.
///
/// Toutes les 4 à 7 secondes, le dino effectue un petit saut spontané
/// (arc sinusoïdal de -20px) pour simuler une vie propre et des comportements
/// imprévisibles. Le prochain saut est replanifié automatiquement après chaque saut.
class JumpAnimation {
  final TickerProvider vsync;

  /// Contrôleur du saut — ne joue qu'une fois par saut (non répété).
  late final AnimationController _jump;

  bool _disposed = false;

  JumpAnimation({required this.vsync}) {
    _jump = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    _scheduleNextJump();
  }

  Animation<double> get jump => _jump;

  /// Décalage vertical en pixels pendant le saut.
  /// Suit une sinusoïde de 0 → -20px → 0 sur la durée du saut.
  double get idleJumpOffsetY {
    if (!_jump.isAnimating) return 0.0;
    return -20.0 * sin(_jump.value * pi);
  }

  /// Planifie le prochain saut avec un délai aléatoire entre 4s et 7s.
  void _scheduleNextJump() {
    final delay = 4000 + Random().nextInt(3000);
    Future.delayed(Duration(milliseconds: delay), () {
      if (_disposed) return;
      _jump.forward(from: 0).then((_) => _scheduleNextJump());
    });
  }

  void dispose() {
    _disposed = true;
    _jump.dispose();
  }
}
