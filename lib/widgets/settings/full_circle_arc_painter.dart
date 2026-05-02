import 'dart:math';
import 'package:flutter/material.dart';

class FullCircleArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double radius;
  final double strokeWidth;

  const FullCircleArcPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.radius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    const double startAngle = -pi / 2;
    const double fullSweep = 2 * pi;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, fullSweep, false, trackPaint);

    if (progress > 0) {
      canvas.drawArc(
        rect,
        startAngle,
        fullSweep * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(FullCircleArcPainter old) =>
      old.progress != progress ||
      old.progressColor != progressColor ||
      old.trackColor != trackColor ||
      old.strokeWidth != strokeWidth;
}
