import 'package:flutter/material.dart';

/// Gère le cycle d'animation des particules étoiles autour du dino.
///
/// 6 étoiles tournent autour du cercle du dino à des vitesses et distances
/// légèrement différentes. Chaque étoile pulse aussi en opacité pour un effet
/// de scintillement. Ce contrôleur fournit uniquement la valeur de progression
/// (0.0 → 1.0) ; le calcul des positions est fait dans DinoStarParticles.
class StarParticleAnimation {
  final TickerProvider vsync;

  /// Cycle de progression des particules — tourne en boucle toutes les 2.5s.
  late final AnimationController _starParticle;

  StarParticleAnimation({required this.vsync}) {
    _starParticle = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  Animation<double> get starParticle => _starParticle;

  /// Valeur brute de progression (0.0 → 1.0) à passer à DinoStarParticles.
  double get progress => _starParticle.value;

  void dispose() {
    _starParticle.dispose();
  }
}
