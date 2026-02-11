import 'dart:math' as math;
import 'package:flutter/material.dart';

class GaugePainter extends CustomPainter {
  final int value;
  final int maxValue;

  GaugePainter({super.repaint, required this.value, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;
    final stroke = 24.0;

    final progress = (value / maxValue).clamp(0.0, 1.0);

    final start = -math.pi;
    final sweep = math.pi;

    final orangeBackgroundPaint = Paint()
      ..color = Color(0xFFFF6B35).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep * 0.25,
      false,
      orangeBackgroundPaint,
    );

    final yellowBackgroundPaint = Paint()
      ..color = Color(0xFFFFD93D).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start + (sweep * 0.25),
      sweep * 0.35,
      false,
      yellowBackgroundPaint,
    );

    final greenBackgroundPaint = Paint()
      ..color = Color(0xFF4CAF50).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start + (sweep * 0.6),
      sweep * 0.4,
      false,
      greenBackgroundPaint,
    );

    // orange 0.25%
    if (progress > 0) {
      final orangeProgress = math.min(progress, 0.25) / 0.25;
      if (orangeProgress > 0) {
        final orangePaint = Paint()
          ..color = Color(0xFFFF6B35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.butt
          ..maskFilter = MaskFilter.blur(BlurStyle.solid, 5);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          start,
          sweep * orangeProgress * 0.25,
          false,
          orangePaint,
        );
      }

      // jaune 35%
      if (progress > 0.25) {
        final yellowProgress = math.min((progress - 0.25) / 0.35, 1.0);
        final yellowPaint = Paint()
          ..color = Color(0xFFFFD93D)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.butt
          ..maskFilter = MaskFilter.blur(BlurStyle.solid, 5);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          start + (sweep * 0.25),
          sweep * yellowProgress * 0.35,
          false,
          yellowPaint,
        );
      }

      // vert 40%
      if (progress > 0.6) {
        final greenProgress = (progress - 0.6) / 0.4;
        final greenPaint = Paint()
          ..color = Color(0xFF4CAF50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.butt
          ..maskFilter = MaskFilter.blur(BlurStyle.solid, 5);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          start + (sweep * 0.6),
          sweep * greenProgress * 0.4,
          false,
          greenPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.maxValue != maxValue;
  }
}
