import 'package:dinopet_walker/controllers/DinoController.dart';
import 'package:dinopet_walker/database/dao/DailyStepsDao.dart';
import 'package:dinopet_walker/services/PedometerService.dart';
import 'package:dinopet_walker/utils/DateFormatter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends ChangeNotifier {
  DinoController dinoController;

  late PedometerService _pedometerService;

  int currentSteps = 0;
  final int goalSteps = 10000;
  bool _isInitialized = false;

  HomeController({required this.dinoController});

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    _pedometerService = PedometerService();

    await Permission.activityRecognition.request();
    await Permission.notification.request();
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    await _pedometerService.initialize();
    currentSteps = _pedometerService.todaySteps;

    dinoController.dinoPet?.addSteps(currentSteps);
    notifyListeners();

    _pedometerService.stepsStream.listen((steps) {
      final difference = steps - currentSteps;
      currentSteps = steps;
      if (difference > 0) dinoController.dinoPet?.addSteps(difference);
      notifyListeners();
      dinoController.notifyListeners();
    });
  }

  Future<void> addSteps(int steps) async {
    dinoController.addSteps(steps);
    notifyListeners();
  }

  @override
  void dispose() {
    _pedometerService.dispose();
    super.dispose();
  }
}
