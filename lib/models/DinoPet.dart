import 'dart:math';
import 'package:dinopet_walker/models/DinoType.dart';
import 'package:dinopet_walker/models/LifeStage.dart';

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

  static int getStepsRequiredForLevel(int level) {
    const int _baseSteps = 5000;
    const double _coefficientOfDifficulty = 1.08;
    return (_baseSteps * pow(_coefficientOfDifficulty, level)).round();
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
