import 'package:dinopet_walker/models/activity/sport_activity.dart';
import 'package:dinopet_walker/models/dino/dino_pet.dart';
import 'package:dinopet_walker/models/dino/dino_type.dart';
import 'package:dinopet_walker/models/daily_steps.dart';
import 'package:dinopet_walker/services/dino_service.dart';
import 'package:dinopet_walker/services/health_service.dart';
import 'package:dinopet_walker/sqlite/dao/daily_steps_dao.dart';
import 'package:dinopet_walker/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class DinoController extends ChangeNotifier {
  DinoPet? _dinoPet;
  DinoPet? get dinoPet => _dinoPet;

  bool _isStravaMode = false;
  bool get isStravaMode => _isStravaMode;

  bool isLoading = true;

  final DinoPetService _dinoPetService = DinoPetService();
  final HealthService _healthService = HealthService();
  final DailyStepsDao _dailyStepsDao = DailyStepsDao();

  // Créer l'objet dino pour la prémière fois et le sauvegarder sur Firestore 
  Future<void> initializeAndSave(DinoType type) async {
    final initialSteps = await _healthService.fetchTodaySteps();
    await _dailyStepsDao.insert(
      DailySteps(
        date: DateFormater.todayString(),
        steps: initialSteps,
        timestamp: DateTime.now(),
        lastSensorValue: initialSteps,
      ),
    );
    _dinoPet = _dinoPetService.createNewDinoPet(
      type,
      initialSteps: initialSteps,
    );
    notifyListeners();
    await _dinoPetService.saveDinoPet(_dinoPet!);
  }

  // Charger le dino depuis Firestore
  Future<void> loadDinoPet() async {
    isLoading = true;
    notifyListeners();

    _dinoPet = await _dinoPetService.loadDinoPet();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addSteps(int steps) async {
    if (_dinoPet == null) return;
    if (_isStravaMode) return;
    _dinoPet!.addXp(steps);
    notifyListeners();
    await _dinoPetService.saveDinoPet(_dinoPet!);
  }

  // Convertir une activité Strava en points (xp) équivalent aux pas.
  int _activityToXp(SportActivity act) {
    if (act.distanceInKm > 0) {
      return (act.distanceInKm * 1000).round();
    }
    return act.durationInMinutes * 100;
  }

  // Ajoute au dino le score des nouvelles activités Strava.
  Future<void> addNewStravaActivities(List<SportActivity> activities) async {
    if (_dinoPet == null) return;

    final savedActivities = Set<String>.from(_dinoPet!.stravaActivitiesIds);
    final today = DateTime.now();

    final newActivities = activities
        .where((a) => !savedActivities.contains(a.id))
        .where(
          (a) =>
              a.date.year == today.year &&
              a.date.month == today.month &&
              a.date.day == today.day,
        )
        .toList();

    if (newActivities.isEmpty) return;

    int totalXp = 0;
    for (final act in newActivities) {
      totalXp += _activityToXp(act);
      _dinoPet!.stravaActivitiesIds.add(act.id);
    }

    _dinoPet!.addXp(totalXp);
    notifyListeners();
    await _dinoPetService.saveDinoPet(_dinoPet!);
  }

  void setStravaMode(bool value) {
    _isStravaMode = value;
  }

  void resetDino() {
    if (_dinoPet == null) return;
    _dinoPet!.level = 1;
    _dinoPet!.xp = 0;
    notifyListeners();
  }
}
