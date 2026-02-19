import 'package:dinopet_walker/models/LifeStage.dart';
import 'package:flutter/material.dart';

class DinoType {
  final String id;
  final String name;
  final String description;
  final Color outColor;
  final Color innerColor;
  final Map<LifeStage, Map<int, String>> assetPaths;

  const DinoType({
    required this.id,
    required this.name,
    required this.description,
    required this.outColor,
    required this.innerColor,
    required this.assetPaths,
  });

  String getAsset(LifeStage stage, int level) {
    final stageAssets = assetPaths[stage];
    if (stageAssets == null || stageAssets.isEmpty) {
      return assetPaths[LifeStage.baby]!.values.first;
    }

    if (stageAssets.containsKey(level)) {
      return stageAssets[level]!;
    }

    // Récupère le dernier asset disponible pour ce niveau ou le premier du stade
    final availableLevels = stageAssets.keys.toList()..sort();
    return stageAssets[availableLevels.lastWhere(
      (lvl) => lvl <= level,
      orElse: () => availableLevels.first,
    )]!;
  }
}
