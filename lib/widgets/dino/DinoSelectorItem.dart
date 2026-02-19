import 'package:dinopet_walker/models/DinoType.dart';
import 'package:dinopet_walker/models/LifeStage.dart';
import 'package:flutter/material.dart';
import '../../models/DinoPet.dart';

class DinoSelectorItem extends StatelessWidget {
  final DinoType dinoType;
  final bool isSelected;
  final VoidCallback onTap;

  const DinoSelectorItem({
    super.key,
    required this.dinoType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
       
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isSelected ? 110 : 80,
          height: isSelected ? 110 : 80,
          margin: const EdgeInsets.symmetric(horizontal: 4),

          decoration: BoxDecoration(
            color: isSelected ? dinoType.innerColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: dinoType.innerColor.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Image.asset(
              dinoType.getAsset(LifeStage.baby, 1),
              fit: BoxFit.contain,
              cacheWidth: 180,
            ),
          ),
        ),
      ),
    );
  }
}
