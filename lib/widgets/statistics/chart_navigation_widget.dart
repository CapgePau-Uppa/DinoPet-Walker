import 'package:flutter/material.dart';

class ChartNavigationWidget extends StatelessWidget {
  final String text;

  const ChartNavigationWidget({super.key, required this.text});

  final Color kDarkTeal = const Color(0xFF2C5F6B);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: kDarkTeal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}