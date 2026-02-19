import 'package:dinopet_walker/widgets/dino/CircularArcPainter.dart';
import 'package:flutter/material.dart';

class CircularArcWidget extends StatelessWidget {
  final double angle;
  final double radius;
  final Color color;
  final double opacity;

  const CircularArcWidget({
    Key? key,
    required this.angle,
    required this.radius,
    required this.color,
    this.opacity = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = radius * 2 + 50;
    return SizedBox(
      width: s,
      height: s,
      child: CustomPaint(
        painter: CircularArcPainter(
          angle: angle,
          radius: radius,
          color: color,
          opacity: opacity,
        ),
      ),
    );
  }
}
