import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GradientPath extends StatelessWidget {
  final List<LatLng> points;

  const GradientPath({
    super.key,
    required this.points
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    final random = Random(42);
    final circles = <CircleMarker>[];
    final Distance distancePath = const Distance();

    final List<Color> colors = [
      const Color(0xFF1100FF),
      const Color(0xFF00D15F), 
      const Color(0xFFFFCC00), 
      const Color(0xFFFF3D00),
    ];

    double totalDistance = 0;
    List<double> distancesAtPoint = [0];
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += distancePath.as(
        LengthUnit.Meter,
        points[i],
        points[i + 1],
      );
      distancesAtPoint.add(totalDistance);
    }

    const double distanceBetweenBubbles = 0.6;
    const double spread = 0.00003;
    final double bubbleRadius = 3.2;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final double distStart = distancesAtPoint[i];
      final double distBetweenTwoPoints = distancePath.as(
        LengthUnit.Meter,
        p1,
        p2,
      );

      int bubblesCount = (distBetweenTwoPoints / distanceBetweenBubbles).round();
      bubblesCount = bubblesCount.clamp(2, 150);

      for (int i = 0; i < bubblesCount; i++) {
        final double progress = i / bubblesCount;
        final double currentMeters = distStart + (distBetweenTwoPoints * progress);
        double totalProgress = totalDistance > 0
            ? (currentMeters / totalDistance)
            : 0.0;
        totalProgress = totalProgress.clamp(0.0, 1.0);

        double indexColor = totalProgress * (colors.length - 1);
        int index = indexColor.floor();
        int nextIndex = (index + 1).clamp(0, colors.length - 1);
        double curseurCouleur = indexColor - index;

        Color finalColor = Color.lerp(
          colors[index],
          colors[nextIndex],
          curseurCouleur,
        )!;

        final latOffset = (random.nextDouble() * 2 - 1) * spread;
        final lngOffset = (random.nextDouble() * 2 - 1) * spread;

        circles.add(
          CircleMarker(
            point: LatLng(
              p1.latitude + (p2.latitude - p1.latitude) * progress + latOffset,
              p1.longitude + (p2.longitude - p1.longitude) * progress + lngOffset,
            ),
            radius: bubbleRadius,
            useRadiusInMeter: false,
            color: finalColor.withValues(alpha: 0.9),
            borderStrokeWidth: 0.3,
            borderColor: Colors.white.withValues(alpha: 0.2),
          ),
        );
      }
    }

    return CircleLayer(circles: circles);
  }
}
