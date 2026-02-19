import 'package:dinopet_walker/widgets/common/BottomNavBarItem.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavBarItem(
                index: 0,
                currentIndex: currentIndex,
                icon: LucideIcons.home,
                activeIcon: LucideIcons.home,
                label: 'Accueil',
                onTap: onTap,
              ),
              BottomNavBarItem(
                index: 1,
                currentIndex: currentIndex,
                icon: LucideIcons.barChart4,
                activeIcon: LucideIcons.barChart4,
                label: 'Statistiques',
                onTap: onTap,
              ),
              BottomNavBarItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.map_outlined,
                activeIcon: Icons.map,
                label: 'Map',
                onTap: onTap,
              ),
              BottomNavBarItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Paramètres',
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
