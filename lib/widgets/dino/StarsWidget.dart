import 'dart:math';
import 'package:flutter/material.dart';

class StarsWidget extends StatefulWidget {
  final double progress; // 0.0 → 1.0
  final double radius;
  final Color color;

  const StarsWidget({
    super.key,
    required this.progress,
    required this.radius,
    required this.color,
  });

  @override
  State<StarsWidget> createState() => _StarsWidgetState();
}

class _StarsWidgetState extends State<StarsWidget> {
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    final rng = Random(7);
    _stars = List.generate(
      14,
      (i) => _Star(
        angle: rng.nextDouble() * 2 * pi,
        distance: 0.9 + rng.nextDouble() * 0.5,
        size: 5 + rng.nextDouble() * 6,
        phase: rng.nextDouble(), // décalage pour scintillement
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opacity = widget.progress < 0.4
        ? widget.progress / 0.4
        : 1.0 - (widget.progress - 0.4) / 0.6;

    return SizedBox(
      width: widget.radius * 4,
      height: widget.radius * 4,
      child: CustomPaint(
        painter: _StarPainter(
          stars: _stars,
          progress: widget.progress,
          opacity: opacity.clamp(0.0, 1.0),
          radius: widget.radius,
          color: widget.color,
        ),
      ),
    );
  }
}

class _Star {
  final double angle;
  final double distance;
  final double size;
  final double phase;
  const _Star({
    required this.angle,
    required this.distance,
    required this.size,
    required this.phase,
  });
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;
  final double opacity;
  final double radius;
  final Color color;

  _StarPainter({
    required this.stars,
    required this.progress,
    required this.opacity,
    required this.radius,
    required this.color,
  });

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outer = Offset(
        center.dx + size * cos((i * 4 * pi / 5) - pi / 2),
        center.dy + size * sin((i * 4 * pi / 5) - pi / 2),
      );
      final inner = Offset(
        center.dx + (size * 0.4) * cos(((i * 4 + 2) * pi / 5) - pi / 2),
        center.dy + (size * 0.4) * sin(((i * 4 + 2) * pi / 5) - pi / 2),
      );
      i == 0
          ? path.moveTo(outer.dx, outer.dy)
          : path.lineTo(outer.dx, outer.dy);
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final star in stars) {
      // scintillement : chaque étoile pulse à sa propre fréquence
      final twinkle =
          0.6 + 0.4 * sin((progress * 3 * pi) + star.phase * 2 * pi);
      final dist = radius * star.distance;

      final pos = Offset(
        center.dx + cos(star.angle) * dist,
        center.dy + sin(star.angle) * dist,
      );

      final paint = Paint()
        ..color = Color.lerp(
          color,
          Colors.white,
          0.5,
        )!.withOpacity((opacity * twinkle).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      _drawStar(canvas, pos, star.size * twinkle, paint);
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) =>
      old.progress != progress || old.opacity != opacity;
}
