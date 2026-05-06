import 'package:dinopet_walker/models/dino/dino_nature.dart';
import 'package:dinopet_walker/models/dino/life_stage.dart';
import 'package:flutter/material.dart';

class DinoType {
  final String id;
  final String name;
  final String description;
  final Color outColor;
  final Color innerColor;
  final Map<LifeStage, Map<int, Map<Nature, String>>> assetPaths;

  const DinoType({
    required this.id,
    required this.name,
    required this.description,
    required this.outColor,
    required this.innerColor,
    required this.assetPaths,
  });

  String getAsset(LifeStage stage,int level, [Nature nature = Nature.terrestre,]) {
    final stageAssets = assetPaths[stage];
    if (stageAssets == null || stageAssets.isEmpty) {
      final babyLevels = assetPaths[LifeStage.baby]!.values.first;
      return babyLevels[Nature.terrestre] ?? babyLevels.values.first;
    }

    final availableLevels = stageAssets.keys.toList()..sort();
    final matchedLevel = availableLevels.lastWhere(
      (lvl) => lvl <= level,
      orElse: () => availableLevels.first,
    );

    final natureMap = stageAssets[matchedLevel]!;

    return natureMap[nature] ?? natureMap[Nature.terrestre] ?? natureMap.values.first;
  }
}
