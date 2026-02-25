import 'dart:math';

import 'package:dinopet_walker/controllers/DinoAnimationController.dart';
import 'package:dinopet_walker/models/DinoPet.dart';
import 'package:dinopet_walker/models/LifeStage.dart';
import 'package:dinopet_walker/models/StarParticle.dart';
import 'package:dinopet_walker/widgets/dino/CircularArcWidget.dart';
import 'package:flutter/material.dart';

class AnimatedDinoWidget extends StatefulWidget {
  final DinoPet dinoPet;
  final VoidCallback? onStageEvolved;

  const AnimatedDinoWidget({
    super.key,
    required this.dinoPet,
    this.onStageEvolved,
  });

  @override
  State<AnimatedDinoWidget> createState() => _AnimatedDinoWidgetState();
}

class _AnimatedDinoWidgetState extends State<AnimatedDinoWidget>
    with TickerProviderStateMixin {
  late DinoAnimationController _controller;

  static const double _boxSize = 420.0;
  static const double _baseCircle = 200.0;
  static const double _imgRatioMin = 0.58;
  static const double _imgRatioMax = 0.84;

  DinoPet? _previousDino;
  bool _isEvolving = false;
  LifeStage? _lastStage;

  @override
  void initState() {
    super.initState();
    _controller = DinoAnimationController(vsync: this);
    _lastStage = widget.dinoPet.currentStage;
  }

  @override
  void didUpdateWidget(covariant AnimatedDinoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newStage = widget.dinoPet.currentStage;

    if (_lastStage != newStage) {
      _previousDino = oldWidget.dinoPet;
      _lastStage = newStage;
      Future.microtask(() {
        _triggerEvolutionAnimation(widget.dinoPet);
      });
    }
  }

  Future<void> _triggerEvolutionAnimation(DinoPet oldDino) async {
    setState(() {
      _previousDino = oldDino;
      _isEvolving = true;
    });
    await _controller.triggerEvolution();
    setState(() {
      _previousDino = null;
      _isEvolving = false;
    });
    widget.onStageEvolved?.call();
  }

  static const Map<LifeStage, List<int>> _levelBounds = {
    LifeStage.baby: [1, 10],
    LifeStage.child: [11, 25],
    LifeStage.teenager: [26, 40],
    LifeStage.adult: [41, 50],
  };

  static const Map<LifeStage, double> _circleScales = {
    LifeStage.baby: 1.00,
    LifeStage.child: 1.28,
    LifeStage.teenager: 1.40,
    LifeStage.adult: 1.50,
  };

  double _imgRatioFor(LifeStage stage, int level) {
    final b = _levelBounds[stage]!;
    final t = ((level - b[0]) / (b[1] - b[0])).clamp(0.0, 1.0);
    return _imgRatioMin + t * (_imgRatioMax - _imgRatioMin);
  }

  double _circleRadiusFor(LifeStage stage, int level) {
    final b = _levelBounds[stage]!;
    final t = ((level - b[0]) / (b[1] - b[0])).clamp(0.0, 1.0);
    final double minRadius = _baseCircle * _circleScales[stage]!;
    final nextStage = stage.nextStage;
    final double maxRadius = nextStage != null
        ? _baseCircle * _circleScales[nextStage]!
        : _baseCircle * _circleScales[stage]!;
    return minRadius + t * (maxRadius - minRadius);
  }

  static final List<StarParticle> _stars = List.generate(6, (i) {
    final rng = Random(i * 42);
    return StarParticle(
      angle: (i / 6) * 2 * pi + rng.nextDouble() * 0.4,
      distance: 0.52 + rng.nextDouble() * 0.12,
      size: 4.0 + rng.nextDouble() * 4.0,
      speed: 0.8 + rng.nextDouble() * 0.5,
    );
  });

  

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final innerColor = widget.dinoPet.type.innerColor;
    final circleDimension = _circleRadiusFor(
      widget.dinoPet.currentStage,
      widget.dinoPet.level,
    );

    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller.breath,
        _controller.breathIntensity,
        _controller.float,
        _controller.pulse,
        _controller.orbit,
        _controller.jump,
        _controller.starParticle,
        _controller.evolveOut,
        _controller.evolveIn,
        _controller.evolveInCurved,
      ]),
      builder: (_, __) {
        final totalOffsetY = _controller.floatY + _controller.idleJumpOffsetY;

        final evolveOutDone =
            _controller.evolveOut.status == AnimationStatus.completed;

        final oldOpacity = _isEvolving
            ? (1.0 - _controller.evolveOut.value).clamp(0.0, 1.0)
            : 0.0;

        final newOpacity = (!_isEvolving || evolveOutDone) ? 1.0 : 0.0;

        final isPopping = _controller.evolveIn.value > 0;

        final finalScale = _isEvolving
            ? _controller.popScale
            : _controller.breathScale;

        return SizedBox(
          width: _boxSize,
          height: _boxSize,
          child: Center(
            child: Transform.translate(
              offset: Offset(0, totalOffsetY),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isEvolving && _previousDino != null)
                    Opacity(
                      opacity: oldOpacity,
                      child: _buildDinoCircle(
                        dino: _previousDino!,
                        innerColor: _previousDino!.type.innerColor,
                      ),
                    ),

                  Opacity(
                    opacity: (_isEvolving && !_controller.evolveOut.isAnimating)
                        ? 1.0
                        : (!_isEvolving ? 1.0 : 0.0),
                    child: Transform.scale(
                      scale: finalScale,
                      child: _buildDinoCircle(
                        dino: widget.dinoPet,
                        innerColor: innerColor,
                      ),
                    ),
                  ),

                  CircularArcWidget(
                    angle: _controller.orbitAngle,
                    radius: circleDimension / 2,
                    color: innerColor,
                  ),

                  ..._buildStarParticles(circleDimension, innerColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDinoCircle({required DinoPet dino, required Color innerColor}) {
    final circleDimension = _circleRadiusFor(dino.currentStage, dino.level);
    final imgDinoDimension =
        circleDimension * _imgRatioFor(dino.currentStage, dino.level);

    return Container(
      height: circleDimension,
      width: circleDimension,
      decoration: BoxDecoration(
        color: dino.type.outColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: innerColor.withOpacity(0.9),
            blurRadius: 25 + _controller.pulseGlow * 50,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipOval(
        child: Center(
          child: Image.asset(
            dino.getCurrentAsset(),
            width: imgDinoDimension,
            height: imgDinoDimension,
            fit: BoxFit.contain,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStarParticles(double circleDimension, Color color) {
    final radius = circleDimension / 2;
    final progress = _controller.starParticle.value;

    return _stars.map((star) {
      final angle = star.angle + progress * 2 * pi * star.speed;
      final dist = radius * star.distance;
      final x = cos(angle) * dist;
      final y = sin(angle) * dist;

      final shimmer =
          0.5 + 0.5 * sin(progress * 2 * pi * star.speed * 3 + star.angle);

      return Transform.translate(
        offset: Offset(x, y),
        child: Opacity(
          opacity: shimmer * 0.85,
          child: Container(
            width: star.size,
            height: star.size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: star.size * 1.5,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
