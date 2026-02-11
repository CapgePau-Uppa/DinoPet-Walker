import 'dart:async';
import 'package:flutter/material.dart';
import '../services/PedometerService.dart';

class HomeController extends ChangeNotifier {
  final PedometerService _pedometerService = PedometerService();

  int currentSteps = 0;
  int userLevel = 10;
  final int goalSteps = 1000;

  StreamSubscription<int>? _stepsSubscription;

  Future<void> init() async {
    await _pedometerService.requestPermission();
    await _pedometerService.initialize();

    currentSteps = _pedometerService.todaySteps;
    notifyListeners();

    _stepsSubscription = _pedometerService.stepsStream.listen((steps) {
      currentSteps = steps;
      notifyListeners();
    });
  }

  void increaseLevel() {
    userLevel += 5;
    notifyListeners();
  }

  void decreaseLevel() {
    userLevel -= 5;
    notifyListeners();
  }

  @override
  void dispose() {
    _stepsSubscription?.cancel();
    super.dispose();
  }
}
