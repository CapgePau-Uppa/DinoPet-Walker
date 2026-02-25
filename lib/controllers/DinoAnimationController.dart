import 'dart:math';
import 'package:flutter/material.dart';

class DinoAnimationController {
  final TickerProvider vsync;

  late AnimationController _breath;
  late AnimationController _breathIntensity;
  late AnimationController _float;
  late AnimationController _pulse;
  late AnimationController _orbit;
  late AnimationController _evolve;
  late AnimationController _jump;
  late AnimationController _starParticle;
  late AnimationController _evolveOut;
  late AnimationController _evolveIn;
  late CurvedAnimation _evolveInCurved;

  DinoAnimationController({required this.vsync}) {
    

    _breath = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _breathIntensity = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    );

    _float = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3800),
    )..repeat();

    _pulse = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _orbit = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _evolve = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    );

    _jump = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    _scheduleIdleJump();

    _starParticle = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

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

  Animation<double> get breath => _breath;
  Animation<double> get breathIntensity => _breathIntensity;
  Animation<double> get float => _float;
  Animation<double> get pulse => _pulse;
  Animation<double> get orbit => _orbit;
  Animation<double> get evolve => _evolve;
  Animation<double> get jump => _jump;
  Animation<double> get starParticle => _starParticle;
  Animation<double> get evolveOut => _evolveOut;
  Animation<double> get evolveIn => _evolveIn;
  Animation<double> get evolveInCurved => _evolveInCurved;

  Future<void> triggerEvolution() async {
    await _evolveOut.forward(from: 0);
    await _evolveIn.forward(from: 0);
    _evolveOut.reset();
    _evolveIn.reset();
  }

  double get breathScale {
    final intensity = _breathIntensity.value;
    final amplitude = 0.038 + intensity * 0.032;
    final baseScale = 0.962 - intensity * 0.012;
    return baseScale + amplitude * sin(_breath.value * 2 * pi);
  }

  double get popScale {
    if (_evolveIn.value == 0) return 1.0;
    return 1.8 - (0.8 * _evolveInCurved.value);
  }

  double get floatY => -7.0 * sin(_float.value * 2 * pi);
  double get pulseGlow => 0.12 + 0.22 * sin(_pulse.value * 2 * pi);

  double get idleJumpOffsetY {
    if (!_jump.isAnimating) return 0.0;
    final t = _jump.value;
    return -20.0 * sin(t * pi);
  }

  double get orbitAngle => _orbit.value * 2 * pi;

  void triggerExcitement() {
    _breathIntensity.forward(from: 0).then((_) {
      if (!_breathIntensity.isDisposed) {
        _breathIntensity.animateTo(
          0.0,
          duration: const Duration(milliseconds: 3000),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scheduleIdleJump() {
    final delay = 4000 + Random().nextInt(3000);
    Future.delayed(Duration(milliseconds: delay), () {
      if (!_jump.isDisposed) {
        _jump.forward(from: 0).then((_) {
          if (!_jump.isDisposed) _scheduleIdleJump();
        });
      }
    });
  }

  void dispose() {
    _breath.dispose();
    _breathIntensity.dispose();
    _float.dispose();
    _pulse.dispose();
    _orbit.dispose();
    _evolve.dispose();
    _jump.dispose();
    _starParticle.dispose();
    _evolveOut.dispose();
    _evolveInCurved.dispose();
    _evolveIn.dispose();
  }
}

extension _SafeController on AnimationController {
  bool get isDisposed {
    try {
      return status == null;
    } catch (_) {
      return true;
    }
  }
}
