import 'package:flutter/material.dart';
import '../../models/DinoPet.dart';

class DinoWidget extends StatelessWidget {
  final DinoPet dinoPet;

  const DinoWidget({super.key, required this.dinoPet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: dinoPet.type.outColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: dinoPet.type.innerColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          dinoPet.getCurrentAsset(),
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          cacheWidth: 400,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
