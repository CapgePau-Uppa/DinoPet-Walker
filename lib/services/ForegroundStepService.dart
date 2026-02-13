import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:dinopet_walker/database/dao/DailyStepsDao.dart';
import 'package:dinopet_walker/models/DailySteps.dart';
import 'dart:async';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundStepService());
}

// c'est le service qui tourne en arrière plan
class ForegroundStepService extends TaskHandler {
  StreamSubscription<StepCount>? _stepSubscription;
  final _dailyStepsDao = DailyStepsDao();

  int _todaySteps = 0;
  int _lastTotalSteps =0; // pour calculer la différence entre la nouvelle et l'ancienne valeur

  Timer? _midnightTimer; // timer pour détecter minuit
  String _currentDate =''; 

  // appelée au démarrage du service
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('service démarré');
    _currentDate = _getTodayString(); // on fixe la date de départ
    await _loadSavedData();
    _startListening();
    _scheduleMidnightReset(); // programmer le reset de minuit
  }

  // appelée périodiquement pour actualiser le nombre de pas en temps réel
  @override
  void onRepeatEvent(DateTime timestamp) {
    // sécurité : vérifier si on a changé de jour
    if (_getTodayString() != _currentDate) {
      _handleMidnightReset();
    }

    FlutterForegroundTask.updateService(
      notificationTitle: 'DinoPet',
      notificationText: 'Pas aujourd\'hui: $_todaySteps',
    );
  }

  // pour arrêter le service
  @override
  Future<void> onDestroy(DateTime timestamp, bool sendPort) async {
    print('service arrêté');
    await _stepSubscription?.cancel();
    _midnightTimer?.cancel(); // annuler le timer
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
  }

  // format ann-mm-jj
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadSavedData() async {
    final todayData = await _dailyStepsDao.getByDate(_currentDate);
    if (todayData != null) {
      _todaySteps = todayData.steps;
      _lastTotalSteps = todayData.lastSensorValue;
      print('données récupérées: $_todaySteps pas / capteur: $_lastTotalSteps');
    } else {
      _todaySteps = 0;
      _lastTotalSteps = 0;
      print('nouveau jour, démarrage à 0');
    }
  }

  // écouter le capteur
  void _startListening() {
    _stepSubscription = Pedometer.stepCountStream.listen(
      (StepCount stepCount) {
        _onStepCount(stepCount.steps);
      },
      onError: (error) {
        print('erreur: $error');
      },
    );
  }

  // programmer le reset à minuit
  void _scheduleMidnightReset() {
    _midnightTimer?.cancel();

    final now = DateTime.now();
    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    final timeUntilMidnight = tomorrow.difference(now);
    // timer pour gérer demain
    _midnightTimer = Timer(timeUntilMidnight, () {
      _handleMidnightReset();
      _scheduleMidnightReset(); 
    });
  }

  Future<void> _handleMidnightReset() async {
    print('nouveau jour ');
    await _saveTodayData();
    _currentDate = _getTodayString();
    _todaySteps = 0; 
    await _saveTodayData();
  }

  // traitement du nombre pas reçus
  Future<void> _onStepCount(int totalSteps) async {
    if (_getTodayString() != _currentDate) {
      await _handleMidnightReset();
      return; 
    }

    if (_lastTotalSteps == 0) {
      _lastTotalSteps = totalSteps;
      await _saveTodayData();
      return;
    }

    // ça veut dire que le tel a redémarré
    if (totalSteps < _lastTotalSteps) {
      _lastTotalSteps = totalSteps;
      await _saveTodayData();
      return;
    }

    // nombre de pas qu'on a fait = chiffre actuel du capteur - la dernière valeur du capteur
    int difference = totalSteps - _lastTotalSteps;
    _todaySteps += difference;
    _lastTotalSteps = totalSteps;

    await _saveTodayData();

    // envoyer les données à l'app
    FlutterForegroundTask.sendDataToMain({
      'todaySteps': _todaySteps,
      'lastTotalSteps': _lastTotalSteps,
    });
  }

  Future<void> _saveTodayData() async {
    await _dailyStepsDao.insert(
      DailySteps(
        date:_currentDate,
        steps: _todaySteps,
        timestamp: DateTime.now(),
        lastSensorValue: _lastTotalSteps,
      ),
    );
  }
}
