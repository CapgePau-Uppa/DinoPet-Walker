import 'dart:async';
import 'package:dinopet_walker/database/DatabaseHelper.dart';
import 'package:dinopet_walker/database/dao/DailyStepsDao.dart';
import 'package:dinopet_walker/models/DailySteps.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerService {
  int todaySteps = 0; // les pas de la journée
  int lastTotalSteps = 0; // le dernier chiffre envoyé par le capteur
  Timer? _midnightTimer; // utilisé pour réinitialiser à minuit
  StreamSubscription<StepCount>? stepSubscription;

  // Instance du DAO
  final _dailyStepsDao = DailyStepsDao();

  // le controller diffuse les pas à toute l'app
  final stepsController = StreamController<int>.broadcast();
  Stream<int> get stepsStream => stepsController.stream;

  Future<void> initialize() async {
    await loadSavedData();
    startListening();
    _scheduleMidnightReset();
  }

  Future<void> requestPermission() async {
    await Permission.activityRecognition.request();
  }

  // format ann-mm-jj
  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String getTodayString() {
    return formatDate(DateTime.now());
  }

  String getYesterdayString() {
    return formatDate(DateTime.now().subtract(const Duration(days: 1)));
  }

  Future<void> loadSavedData() async {
    final todayData = await _dailyStepsDao.getByDate(getTodayString());

    if (todayData != null) {
      todaySteps = todayData.steps;
      print("Données récupérées pour aujourd'hui : $todaySteps pas");
    } else {
      todaySteps = 0;
      print("Nouveau jour détecté");
    }
    lastTotalSteps = 0;
  }

  void startListening() {
    stepSubscription = Pedometer.stepCountStream.listen(
      (StepCount stepCount) {
        onStepCount(stepCount.steps);
      },
      onError: (error) {
        print("Erreur pedometer: $error");
      },
    );
  }

  void stopListening() {
    stepSubscription?.cancel();
  }

  Future<void> onStepCount(int totalSteps) async {
    if (lastTotalSteps == 0) {
      lastTotalSteps = totalSteps;
      return;
    }

    int difference = totalSteps - lastTotalSteps;
    if (difference < 0) {
      difference = totalSteps;
    }

    todaySteps = todaySteps + difference;
    lastTotalSteps = totalSteps;

    await _dailyStepsDao.insert(
      DailySteps(
        date: getTodayString(),
        steps: todaySteps,
        timestamp: DateTime.now(),
      ),
    );

    if (!stepsController.isClosed) {
      stepsController.add(todaySteps);
    }
    print("Pas aujourd'hui : $todaySteps");
  }

  // Timer pour reset à minuit
  void _scheduleMidnightReset() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    print("Prochain reset dans: ${timeUntilMidnight.inMinutes} minutes");

    _midnightTimer = Timer(timeUntilMidnight, () async {
      await _handleMidnightReset();
      _scheduleMidnightReset();
    });
  }

  Future<void> _handleMidnightReset() async {
    todaySteps = 0;
    lastTotalSteps = 0;

    if (!stepsController.isClosed) {
      stepsController.add(0);
    }
    print("Nouveau jour : ${getTodayString()}");
  }

  Future<int> getYesterdaySteps() async {
    final data = await _dailyStepsDao.getByDate(getYesterdayString());
    return data?.steps ?? 0;
  }

  Future<void> reset() async {
    todaySteps = 0;
    lastTotalSteps = 0;

    final db = await DatabaseHelper.instance.database;
    await db.delete('daily_steps');

    if (!stepsController.isClosed) {
      stepsController.add(0);
    }
  }

  void dispose() {
    stepSubscription?.cancel();
    _midnightTimer?.cancel();
    stepsController.close();
  }
}
