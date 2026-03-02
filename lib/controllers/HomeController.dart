import 'package:dinopet_walker/controllers/DinoController.dart';
import 'package:dinopet_walker/services/HealthService.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends ChangeNotifier {
  DinoController dinoController;
  late HealthService _healthService;

  int _currentSteps = 0;
  final int _goalSteps = 10000;
  bool _isInitialized = false;

  int get currentSteps => _currentSteps;
  int get goalSteps => _goalSteps;

  HomeController({required this.dinoController});



  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await Permission.activityRecognition.request();

    _healthService = HealthService();
    await _healthService.initialize();

    _currentSteps = _healthService.todaySteps;
    dinoController.dinoPet?.addSteps(_currentSteps);
    notifyListeners();

    _healthService.stepsStream.listen((steps) {
      final difference = steps - _currentSteps;
      _currentSteps = steps;
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
    _healthService.dispose();
    super.dispose();
  }
}
