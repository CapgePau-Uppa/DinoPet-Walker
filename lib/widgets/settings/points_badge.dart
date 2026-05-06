import 'package:flutter/material.dart';

class PointsBadge extends StatelessWidget {
  final int xp;
  final int xpMax;

  const PointsBadge({super.key, required this.xp, required this.xpMax});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF0B6666).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ' $xp / $xpMax',
            style: const TextStyle(fontSize: 15, color: Color(0xFF004D40)),
          ),

          Text(
            '  XP',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF004D40),
            ),
          ),

          const SizedBox(width: 0),

          Image.asset(
            'assets/icons/flash.png',
            width: 18,
            height: 18,
          ),
        ],
      ),
    );
  }
}
