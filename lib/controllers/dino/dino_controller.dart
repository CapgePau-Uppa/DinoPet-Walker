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
    _dinoPet!.addSteps(steps);
    notifyListeners();
    await _dinoPetService.saveDinoPet(_dinoPet!);
  }

  void resetDino() {
    if (_dinoPet == null) return;
    _dinoPet!.level = 1;
    _dinoPet!.xpSteps = 0;
    notifyListeners();
  }
}
