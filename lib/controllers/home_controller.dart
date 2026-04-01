import 'package:dinopet_walker/controllers/dino_controller.dart';
import 'package:dinopet_walker/services/health_service.dart';
import 'package:dinopet_walker/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ChangeNotifier {
  DinoController dinoController;
  late HealthService _healthService;

  int _currentSteps = 0;
  int _goalSteps = 10000;
  bool _isInitialized = false;

  int _goalTime = 30;
  int _goalDistance = 5;

  bool isGoalSet = false;
  bool isLoadingGoal = true;

  int get currentSteps => _currentSteps;
  int get goalSteps => _goalSteps;
  int get goalTime => _goalTime;
  int get goalDistance => _goalDistance;

  HomeController({required this.dinoController});

  final UserService _userService = UserService();

  Future<void> loadGoal() async {
    final prefs = await SharedPreferences.getInstance();

    isGoalSet = prefs.getBool('isGoalSet') ?? false;

    if (!isGoalSet) {
      final user = await _userService.getCurrentUser();
      if (user != null) {

        if (user.goalSteps != null) {
          await prefs.setInt('goalSteps', user.goalSteps!);
        }

        if (user.goalTime != null) {
          await prefs.setInt('goalTime', user.goalTime!);
        }
        if (user.goalDistance != null) {
          await prefs.setInt('goalDistance', user.goalDistance!);
        }

        await prefs.setBool('isGoalSet', true);
        isGoalSet = true;
      }
    }

    if (isGoalSet) {
      _goalSteps = prefs.getInt('goalSteps') ?? 10000;
      _goalTime = prefs.getInt('goalTime') ?? 30;
      _goalDistance = prefs.getInt('goalDistance') ?? 5;
    }

    isLoadingGoal = false;
    notifyListeners();
  }

  Future<void> updateGoalSteps(int newGoal) async {
    _goalSteps = newGoal;
    isGoalSet = true;
    notifyListeners();

    _userService.updateGoalSteps(newGoal);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('goalSteps', newGoal);
    await prefs.setBool('isGoalSet', true);
  }

  Future<void> updateGoalTime(int newTime) async {
    _goalTime = newTime;
    notifyListeners();

    _userService.updateGoalTime(newTime);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('goalTime', newTime);
  }

  Future<void> updateGoalDistance(int newDistance) async {
    _goalDistance = newDistance;
    notifyListeners();

    _userService.updateGoalDistance(newDistance);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('goalDistance', newDistance);
  }

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