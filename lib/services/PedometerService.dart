import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:dinopet_walker/database/dao/DailyStepsDao.dart';
import 'package:dinopet_walker/services/BackgroundStepsService.dart';

// ce service recoit les données envoyées par le service en arrière plan et met a jour l'interface
class PedometerService {
  int todaySteps = 0;
  int lastTotalSteps = 0;
  final _dailyStepsDao = DailyStepsDao();
  final stepsController = StreamController<int>.broadcast();
  Stream<int> get stepsStream => stepsController.stream;
  Timer? _updateTimer;

  Future<void> initialize() async {
    await _initForegroundTask(); // configurer les options du service
    await loadSavedData();
    await _startForegroundService();

    // écouter les données envoyées par le service 
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    _startPeriodicUpdate();
  }

  // recevoir les données directement du BackgroundStepsService
  void _onReceiveTaskData(Object data) {
    if (data is Map<String, dynamic>) {
      final newSteps = data['todaySteps'] as int?;
      if (newSteps != null && newSteps != todaySteps) {
        todaySteps = newSteps;
        if (!stepsController.isClosed) {
          stepsController.add(todaySteps);
        }
      }
    }
  }

  Future<void> _initForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'step_channel',
        channelName: 'step counter service',
        channelDescription: 'ce canal est pour compter les pas en arrière plan',
        // Notification discrete ni son ni vibration
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot:true, // pour lancer le service après un redémarrage du tel
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  Future<void> _startForegroundService() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.restartService();
    } else {
      await FlutterForegroundTask.startService(
        serviceId: 123,
        notificationTitle: 'DinoPet Walker',
        notificationText: 'Comptage des pas actif',
        callback: startCallback,
      );
    }
  }

  void _startPeriodicUpdate() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await loadSavedData();
    });
  }

  Future<void> loadSavedData() async {
    final todayData = await _dailyStepsDao.getByDate(_getTodayString());
    if (todayData != null) {
      final newSteps = todayData.steps;
      final newSensorValue = todayData.lastSensorValue;
      if (newSteps != todaySteps || newSensorValue != lastTotalSteps) {
        todaySteps = newSteps;
        lastTotalSteps = newSensorValue;
        if (!stepsController.isClosed) {
          stepsController.add(todaySteps);
        }
      }
    }
  }

  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> stopService() async {
    _updateTimer?.cancel();
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    await FlutterForegroundTask.stopService();
  }

  void dispose() {
    _updateTimer?.cancel();
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    stepsController.close();
  }
}
