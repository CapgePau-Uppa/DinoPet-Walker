import 'package:flutter/material.dart';

class PermissionIllustration extends StatelessWidget {
  const PermissionIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
        ),
        Image.asset('assets/images/cracked_egg.png', width: 120, height: 120)
      ],
    );
  }
}
