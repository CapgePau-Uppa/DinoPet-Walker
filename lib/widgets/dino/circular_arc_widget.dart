import 'package:dinopet_walker/widgets/dino/circular_arc_painter.dart';
import 'package:flutter/material.dart';

class CircularArcWidget extends StatelessWidget {
  final double angle;
  final double radius;
  final Color color;
  final double opacity;

  const CircularArcWidget({
    super.key,
    required this.angle,
    required this.radius,
    required this.color,
    this.opacity = 1.0,
  });

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
