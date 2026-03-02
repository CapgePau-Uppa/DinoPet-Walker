import 'dart:async';
import 'package:health/health.dart';
import 'package:dinopet_walker/database/dao/DailyStepsDao.dart';
import 'package:dinopet_walker/models/DailySteps.dart';
import 'package:dinopet_walker/utils/DateFormatter.dart';

class HealthService {
  final _health = Health();
  final _dailyStepsDao = DailyStepsDao();

  int todaySteps = 0;

  final _stepsController = StreamController<int>.broadcast();
  Stream<int> get stepsStream => _stepsController.stream;
  // timer pour intteroger health sur les pas chaque 10 secondes
  Timer? _timer;

  Future<void> initialize() async {
    // initialiser le plugin et établir la connexion avec health connect
    await _health.configure();
    // demander l'autorisation d'acceder aux données 
    final agree = await _health.requestAuthorization(
      [HealthDataType.STEPS],
      permissions: [HealthDataAccess.READ],
    );
    if (!agree) {
      print('permissionsrefusées');
      return;
    }
    // charger les données sauvegardées en bdd
    await _loadSavedData();

    // interroger health
    await _fetchSteps();

    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      await _fetchSteps();
    });
  }

  Future<void> _fetchSteps() async {
    try {
      final now = DateTime.now();
      final starDay = DateTime(now.year, now.month, now.day);
      // les pas a partir de 00h00 jusqu'a maintenent
      final steps = await _health.getTotalStepsInInterval(starDay, now);

      if (steps != null && steps != todaySteps) {
        todaySteps = steps;
        await _save();
        if (!_stepsController.isClosed) {
          _stepsController.add(todaySteps);
        }
      }
    } catch (e) {
      print('erreur health: $e');
    }
  }

  Future<void> _loadSavedData() async {
    final saved = await _dailyStepsDao.getByDate(DateFormater.todayString());
    if (saved != null) {
      todaySteps = saved.steps;
    }
  }

  Future<void> _save() async {
    await _dailyStepsDao.insert(
      DailySteps(
        date: DateFormater.todayString(),
        steps: todaySteps,
        timestamp: DateTime.now(),
        lastSensorValue: todaySteps,
      ),
    );
  }

  void dispose() {
    _timer?.cancel();
    _stepsController.close();
  }
}
