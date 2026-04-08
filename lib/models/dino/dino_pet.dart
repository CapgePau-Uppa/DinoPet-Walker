import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinopet_walker/data/dino_data.dart';
import 'package:dinopet_walker/models/dino/dino_type.dart';
import 'package:dinopet_walker/models/dino/life_stage.dart';

class DinoPet {
  final String id;
  final DinoType type;
  int level;
  int xpSteps;
  DateTime adoptedDate;

  DinoPet({
    required this.id,
    required this.type,
    this.level = 1,
    this.xpSteps = 0,
    DateTime? adoptedDate,
  }) : adoptedDate = adoptedDate ?? DateTime.now();

  factory DinoPet.fromFirestore(String id, Map<String, dynamic> data) {
    final dinoType = availableDinos.firstWhere(
      (d) => d.id == data['typeId'],
      orElse: () => availableDinos.first,
    );
    return DinoPet(
      id: id,
      type: dinoType,
      level: data['level'] as int? ?? 1,
      xpSteps: data['xpSteps'] as int? ?? 0,
      adoptedDate:
          (data['adoptedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'typeId': type.id,
      'level': level,
      'xpSteps': xpSteps,
      'adoptedDate': Timestamp.fromDate(adoptedDate),
    };
  }

  static int getStepsRequiredForLevel(int level) {
    const int baseSteps = 5000;
    const double coefficientOfDifficulty = 1.08;
    return (baseSteps * pow(coefficientOfDifficulty, level)).round();
  }

  int get stepsRequiredForNextLevel =>
      level >= 50 ? 0 : getStepsRequiredForLevel(level + 1);

  double get progressToNextLevel {
    if (level >= 50) return 100.0;
    final required = stepsRequiredForNextLevel;
    return (xpSteps / required * 100).clamp(0, 100);
  }

  int getTotalStepsCollected() {
    int total = xpSteps;
    for (int i = 2; i <= level; i++) {
      total += getStepsRequiredForLevel(i);
    }
    return total;
  }

  void addSteps(int steps) {
    if (level >= 50) return;
    xpSteps += steps;
    while (xpSteps >= stepsRequiredForNextLevel && level < 50) {
      xpSteps -= stepsRequiredForNextLevel;
      level++;
    }
  }

  LifeStage get currentStage {
    if (level <= 10) return LifeStage.baby;
    if (level <= 25) return LifeStage.child;
    if (level <= 40) return LifeStage.teenager;
    return LifeStage.adult;
  }

  String getCurrentAsset() => type.getAsset(currentStage, level);
}
