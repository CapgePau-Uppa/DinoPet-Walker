import 'dart:math';
import 'package:flutter/material.dart';

class CircularArcPainter extends CustomPainter {
  final double angle, radius, opacity;
  final Color color;
  CircularArcPainter({
    required this.angle,
    required this.radius,
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * opacity
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          color.withOpacity(0.6 * opacity),
          Colors.transparent,
        ],
        startAngle: angle - pi * 0.65,
        endAngle: angle,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle - pi * 0.65,
      pi * 0.65,
      false,
      trailPaint,
    );

    
  }

  @override
  bool shouldRepaint(CircularArcPainter o) =>
      o.angle != angle || o.opacity != opacity;
}
