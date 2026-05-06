import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinopet_walker/data/dino_data.dart';
import 'package:dinopet_walker/models/dino/dino_nature.dart';
import 'package:dinopet_walker/models/dino/dino_type.dart';
import 'package:dinopet_walker/models/dino/life_stage.dart';

class DinoPet {
  final String id;
  final DinoType type;
  int level;
  int xp;
  DateTime adoptedDate;
  List<String> stravaActivitiesIds; 

  DinoPet({
    required this.id,
    required this.type,
    this.level = 1,
    this.xp = 0,
    DateTime? adoptedDate,
    List<String>? stravaActivitiesIds,
  }) : adoptedDate = adoptedDate ?? DateTime.now(),
       stravaActivitiesIds = stravaActivitiesIds ?? [];

  factory DinoPet.fromFirestore(String id, Map<String, dynamic> data) {
    final dinoType = availableDinos.firstWhere(
      (d) => d.id == data['typeId'],
      orElse: () => availableDinos.first,
    );
    return DinoPet(
      id: id,
      type: dinoType,
      level: data['level'] as int? ?? 1,
      xp: data['xp'] as int? ?? 0,
      adoptedDate: (data['adoptedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      stravaActivitiesIds: List<String>.from(data['stravaActivitiesIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'typeId': type.id,
      'level': level,
      'xp': xp,
      'adoptedDate': Timestamp.fromDate(adoptedDate),
      'stravaActivitiesIds': stravaActivitiesIds,
    };
  }

  int get xpRequiredForNextLevel =>
      level >= 50 ? 0 : getXpRequiredForLevel(level + 1);

  void addXp(int amount) {
    if (level >= 50) return;
    xp += amount;
    while (xp >= xpRequiredForNextLevel && level < 50) {
      xp -= xpRequiredForNextLevel;
      level++;
    }
  }

  LifeStage get currentStage {
    if (level <= 10) return LifeStage.baby;
    if (level <= 25) return LifeStage.child;
    if (level <= 40) return LifeStage.teenager;
    return LifeStage.adult;
  }

  String getCurrentAsset([Nature nature = Nature.terrestre]) =>
      type.getAsset(currentStage, level, nature);

  int getTotalXpCollected() {
    int total = xp;
    for (int i = 2; i <= level; i++) {
      total += getXpRequiredForLevel(i);
    }
    return total;
  }

  int getXpRequiredForLevel(int level) {
    const int baseSteps = 5000;
    const double coefficientOfDifficulty = 1.05;
    return (baseSteps * pow(coefficientOfDifficulty, level)).round();
  }
}
