import 'package:flutter/material.dart';

class DailyStatsWidget extends StatelessWidget {
  final int steps;
  final String percentage;
  final String distance;
  final bool isUp;

  const DailyStatsWidget({
    super.key,
    required this.steps,
    required this.percentage,
    required this.distance,
    this.isUp = true,
  });

  final Color kGreenText = const Color(0xFF4CAF50);
  final Color kRedText = const Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final currentColor = isUp ? kGreenText : kRedText;
    final currentIcon = isUp ? Icons.arrow_upward : Icons.arrow_downward;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "$steps",
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "pas",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: currentColor, width: 2),
                    ),
                    child: Icon(currentIcon, color: currentColor, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        percentage,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "par rapport à hier",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Distance parcourue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                distance,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black),
              ),
            ],
          )
        ],
      ),
    );
  }
}