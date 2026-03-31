import 'package:flutter/material.dart';

class StepWidget extends StatelessWidget {
  final String number;
  final String text;

  const StepWidget({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF1B3A2D).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF1B3A2D),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF1B3A2D).withValues(alpha: 0.6),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
