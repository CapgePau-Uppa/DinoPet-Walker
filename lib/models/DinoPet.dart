import 'dart:math';
import 'package:flutter/material.dart';

enum LifeStage {
  baby,
  child,
  teenager,
  adult;
  String get getName {
    switch (this) {
      case LifeStage.baby:
        return 'Bébé';
      case LifeStage.child:
        return 'Enfant';
      case LifeStage.teenager:
        return 'Adolescent';
      case LifeStage.adult:
        return 'Adulte';
    }
  }

  int get minLevel {
    switch (this) {
      case LifeStage.baby:
        return 1;
      case LifeStage.child:
        return 11;
      case LifeStage.teenager:
        return 26;
      case LifeStage.adult:
        return 41;
    }
  }

  int get maxLevel {
    switch (this) {
      case LifeStage.baby:
        return 10;
      case LifeStage.child:
        return 25;
      case LifeStage.teenager:
        return 40;
      case LifeStage.adult:
        return 50;
    }
  }

  LifeStage? get nextStage {
    switch (this) {
      case LifeStage.baby:
        return LifeStage.child;
      case LifeStage.child:
        return LifeStage.teenager;
      case LifeStage.teenager:
        return LifeStage.adult;
      case LifeStage.adult:
        return null;
    }
  }
}

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

  String getAsset(LifeStage stage,int level) {
    final stageAssets = assetPaths[stage];
    if (stageAssets == null || stageAssets.isEmpty) {
      return assetPaths[LifeStage.baby]!.values.first;
    }
    if (stageAssets[level] != null) {
      return stageAssets[level]!;
    }
    final availableLevels = stageAssets.keys.toList()..sort();
    for (int i = availableLevels.length - 1; i >= 0; i--) {
      if (availableLevels[i] <= level) {
        return stageAssets[availableLevels[i]]!;
      }
    }
    return stageAssets[availableLevels.first]!;
  }

}

class DinoPetInstance {
  final String id;
  final DinoType type;
  int level;
  int currentSteps;
  int dailyStepsGoal;
  DateTime adoptedDate;

  DinoPetInstance({
    required this.id,
    required this.type,
    this.level = 1,
    this.currentSteps = 0,
    this.dailyStepsGoal = 5000,
    DateTime? adoptedDate,
  }) : adoptedDate = adoptedDate ?? DateTime.now();

  
  int getStepsRequiredForLevel(int level) {
    const int base = 5000;
    const double coefficient = 1.08; //+8 % de difficulté par niveau
    return (base * pow(coefficient, level)).round();
  }

  int get stepsRequiredForNextLevel {
    if (level >= 50) return 0;
    return getStepsRequiredForLevel(level + 1);
  }

  double get progressToNextLevel {
    if (level >= 50) return 100.0;
    final required = stepsRequiredForNextLevel;
    if (required == 0) return 100.0;
    return (currentSteps / required * 100).clamp(0, 100);
  }

  void addSteps(int steps) {
    if (level >= 50) return;
    currentSteps += steps;
    while (currentSteps >= stepsRequiredForNextLevel && level < 50) {
      currentSteps -= stepsRequiredForNextLevel;
      level++;
    }
  }

  LifeStage get currentStage {
    if (level <= 10) return LifeStage.baby;
    if (level <= 25) return LifeStage.child;
    if (level <= 40) return LifeStage.teenager;
    return LifeStage.adult;
  }

  double get stageProgress {
    final stage = currentStage;
    final progress = level - stage.minLevel;
    final total = stage.maxLevel - stage.minLevel;
    return (progress / total * 100).clamp(0, 100);
  }

  bool isMaxLevel() => level >= 50;

  String getCurrentAsset() => type.getAsset(currentStage, level);

  int getTotalStepsCollected() {
    int total = currentSteps;
    for (int i = 2; i <= level; i++) {
      total += getStepsRequiredForLevel(i);
    }
    return total;
  }

}


