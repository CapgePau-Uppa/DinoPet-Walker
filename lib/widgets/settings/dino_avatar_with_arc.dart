import 'package:dinopet_walker/models/dino/dino_pet.dart';
import 'package:dinopet_walker/widgets/settings/full_circle_arc_painter.dart';
import 'package:flutter/material.dart';

class DinoAvatarWithArc extends StatelessWidget {
  final DinoPet dino;
  final dynamic nature;
  final double xpProgress;

  const DinoAvatarWithArc({
    super.key,
    required this.dino,
    required this.nature,
    required this.xpProgress,
  });

  static const double _avatarSize = 100.0;
  static const double _arcRadius = 64.0;
  static const double _boxSize = 140.0;

  @override
  Widget build(BuildContext context) {
    final String asset = dino.getCurrentAsset(nature);
    final Color innerColor = dino.type.innerColor;
    final Color outColor = dino.type.outColor;

    return SizedBox(
      width: _boxSize,
      height: _boxSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(_boxSize, _boxSize),
            painter: FullCircleArcPainter(
              progress: xpProgress,
              trackColor: const Color(0xFFCFD8DC),
              progressColor: const Color(0xFF004D40),
              radius: _arcRadius,
              strokeWidth: 7.0,
            ),
          ),
          Container(
            width: _avatarSize,
            height: _avatarSize,
            decoration: BoxDecoration(
              color: outColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: innerColor,
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  asset,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
