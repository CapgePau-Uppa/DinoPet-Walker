import 'dart:async';
import 'package:dinopet_walker/sqlite/dao/daily_steps_dao.dart';
import 'package:dinopet_walker/models/daily_steps.dart';
import 'package:dinopet_walker/utils/date_formatter.dart';
import 'package:health/health.dart';

class HealthService {
  final _health = Health();
  final _dailyStepsDao = DailyStepsDao();

  int todaySteps = 0;
  int lastSensorValue = 0;

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
      //print('permissionsrefusées');
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

      if (steps == null) return;

      if (steps != todaySteps || steps != lastSensorValue) {
        var difference = steps - lastSensorValue;
        if (difference < 0) {
          difference = steps;
        }

        todaySteps = steps;
        lastSensorValue = steps;

        await _save();
        if (difference > 0 && !_stepsController.isClosed) {
          _stepsController.add(difference);
        }
      }
    } catch (e) {
      //print('erreur health: $e');
    }
  }

  Future<void> refreshNow() async {
    await _fetchSteps();
  }

  Future<void> _loadSavedData() async {
    final saved = await _dailyStepsDao.getByDate(DateFormater.todayString());
    if (saved != null) {
      todaySteps = saved.steps;
      lastSensorValue = saved.lastSensorValue;
    }
  }

  Future<void> _save() async {
    await _dailyStepsDao.insert(
      DailySteps(
        date: DateFormater.todayString(),
        steps: todaySteps,
        timestamp: DateTime.now(),
        lastSensorValue: lastSensorValue,
      ),
    );
  }

  Future<int> fetchTodaySteps() async {
    await _health.configure();
    final agree = await _health.requestAuthorization(
      [HealthDataType.STEPS],
      permissions: [HealthDataAccess.READ],
    );
    if (!agree) return 0;

    final now = DateTime.now();
    final startDay = DateTime(now.year, now.month, now.day);
    final steps = await _health.getTotalStepsInInterval(startDay, now);
    return steps ?? 0;
  }

  void dispose() {
    _timer?.cancel();
    _stepsController.close();
  }
}
