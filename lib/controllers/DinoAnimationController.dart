import 'dart:math';
import 'package:flutter/material.dart';

class DinoAnimationController {
  final TickerProvider vsync;

  late AnimationController breath;
  late AnimationController float;
  late AnimationController pulse;
  late AnimationController orbit;
  late AnimationController evolve;

  late AnimationController idleJump; // petit saut périodique
  late AnimationController starParticle; // particules en orbite

  DinoAnimationController({required this.vsync}) {
    breath = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    float = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3800),
    )..repeat();

    pulse = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    orbit = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    evolve = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    );

    idleJump = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    _scheduleIdleJump();


    //particules en orbite rapide
    starParticle = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  double get breathScale => 0.962 + 0.038 * sin(breath.value * 2 * pi);
  double get floatY => -7.0 * sin(float.value * 2 * pi);
  double get pulseGlow => 0.12 + 0.22 * sin(pulse.value * 2 * pi);

  // offset vertical du saut idle (monte puis descend)
  double get idleJumpOffsetY {
    if (!idleJump.isAnimating) return 0.0;
    final t = idleJump.value;
    return -20.0 * sin(t * pi);
  }

  // planification su saut
  void _scheduleIdleJump() {
    final delay = 4000 + Random().nextInt(3000); // 4–7 s
    Future.delayed(Duration(milliseconds: delay), () {
      if (!idleJump.isDisposed) {
        idleJump.forward(from: 0).then((_) {
          if (!idleJump.isDisposed) _scheduleIdleJump();
        });
      }
    });
  }



  void dispose() {
    breath.dispose();
    float.dispose();
    pulse.dispose();
    orbit.dispose();
    evolve.dispose();
    idleJump.dispose();
    starParticle.dispose();
  }
}

//pour vérifier si un controller est disposé
extension _SafeController on AnimationController {
  bool get isDisposed {
    try {
      // ignore: unnecessary_null_comparison
      return status == null;
    } catch (_) {
      return true;
    }
  }
}
