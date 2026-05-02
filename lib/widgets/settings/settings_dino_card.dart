import 'package:dinopet_walker/controllers/activity/activity_controller.dart';
import 'package:dinopet_walker/controllers/dino/dino_controller.dart';
import 'package:dinopet_walker/widgets/settings/points_badge.dart';
import 'package:dinopet_walker/widgets/settings/dino_avatar_with_arc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsDinoCard extends StatelessWidget {
  const SettingsDinoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dino = context.watch<DinoController>().dinoPet;
    final nature = context.watch<ActivityController>().dinoNature;

    if (dino == null) return const SizedBox.shrink();

    final double xpProgress = dino.xpRequiredForNextLevel > 0
        ? (dino.xp / dino.xpRequiredForNextLevel).clamp(0.0, 1.0)
        : 1.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DinoAvatarWithArc(dino: dino, nature: nature, xpProgress: xpProgress),
        const SizedBox(height: 16),
        PointsBadge(xp: dino.xp, xpMax: dino.xpRequiredForNextLevel),
      ],
    );
  }
}
