import 'package:flutter/material.dart';

class AverageCardWidget extends StatelessWidget {
  final String title;
  final String steps;
  final String percentage;
  final String subtitle;
  final bool isUp;

  const AverageCardWidget({
    super.key,
    required this.title,
    required this.steps,
    required this.percentage,
    required this.subtitle,
    required this.isUp,
  });

  final Color kGreenText = const Color(0xFF4CAF50);
  final Color kRedText = const Color(0xFFE53935);
  final Color kCardGradStart = const Color(0xFFB2EBF2);
  final Color kCardGradEnd = const Color(0xFFDCEDC8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kCardGradStart, kCardGradEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                steps,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
              ),
              const SizedBox(width: 4),
              const Text(
                "pas",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isUp ? kGreenText : kRedText, width: 2),
                ),
                child: Icon(
                  isUp ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isUp ? kGreenText : kRedText,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                percentage,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}