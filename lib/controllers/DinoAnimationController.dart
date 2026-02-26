import 'package:dinopet_walker/animations/BreathAnimation.dart';
import 'package:dinopet_walker/animations/EvolutionAnimation.dart';
import 'package:dinopet_walker/animations/FloatAnimation.dart';
import 'package:dinopet_walker/animations/JumpAnimation.dart';
import 'package:dinopet_walker/animations/OrbitAnimation.dart';
import 'package:dinopet_walker/animations/PulseAnimation.dart';
import 'package:dinopet_walker/animations/StarParticleAnimation.dart';
import 'package:flutter/material.dart';

class DinoAnimationController {
  final TickerProvider vsync;

  late final BreathAnimation _breath;
  late final FloatAnimation _float;
  late final PulseAnimation _pulse;
  late final OrbitAnimation _orbit;
  late final JumpAnimation _jump;
  late final StarParticleAnimation _starParticle;
  late final EvolutionAnimation _evolution;

  DinoAnimationController({required this.vsync}) {
    _breath = BreathAnimation(vsync: vsync);
    _float = FloatAnimation(vsync: vsync);
    _pulse = PulseAnimation(vsync: vsync);
    _orbit = OrbitAnimation(vsync: vsync);
    _jump = JumpAnimation(vsync: vsync);
    _starParticle = StarParticleAnimation(vsync: vsync);
    _evolution = EvolutionAnimation(vsync: vsync);
  }

  //breath 
  Animation<double> get breath => _breath.breath;
  Animation<double> get breathIntensity => _breath.breathIntensity;
  double get breathScale => _breath.breathScale;

  //float
  Animation<double> get float => _float.float;
  double get floatY => _float.floatY;

  //pulse

  Animation<double> get pulse => _pulse.pulse;
  double get pulseGlow => _pulse.pulseGlow;

  //orbit
  Animation<double> get orbit => _orbit.orbit;
  double get orbitAngle => _orbit.orbitAngle;

  //jump
  Animation<double> get jump => _jump.jump;
  double get idleJumpOffsetY => _jump.idleJumpOffsetY;

  //star
  Animation<double> get starParticle => _starParticle.starParticle;

  //evolution
  Animation<double> get evolveOut => _evolution.evolveOut;
  Animation<double> get evolveIn => _evolution.evolveIn;
  Animation<double> get evolveInCurved => _evolution.evolveInCurved;
  double get popScale => _evolution.popScale;

  Future<void> triggerEvolution() => _evolution.triggerEvolution();

  void triggerExcitement() => _breath.triggerExcitement();

  void dispose() {
    _breath.dispose();
    _float.dispose();
    _pulse.dispose();
    _orbit.dispose();
    _jump.dispose();
    _starParticle.dispose();
    _evolution.dispose();
  }
}
