import 'package:flutter/material.dart';

class DateBadgeWidget extends StatelessWidget {
  final String date;

  const DateBadgeWidget({super.key, required this.date});

  final Color kLightGreenBadge = const Color(0xFFE8F5E9);
  final Color kGreenText = const Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      decoration: BoxDecoration(
        color: kLightGreenBadge,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: kGreenText.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: kGreenText,
        ),
      ),
    );
  }
}