import 'package:dinopet_walker/controllers/dino/dino_controller.dart';
import 'package:dinopet_walker/services/permission_service.dart';
import 'package:dinopet_walker/services/health_service.dart';
import 'package:dinopet_walker/services/user_service.dart';
import 'package:dinopet_walker/services/streak_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ChangeNotifier {
  DinoController dinoController;
  late HealthService _healthService;

  int _currentSteps = 0;
  int _goalSteps = 10000;
  bool _isInitialized = false;

  int? _goalTime;
  int? _goalDistance;

  bool isGoalSet = false;
  bool isLoadingGoal = true;

  int _streak = 0;
  int get streak => _streak;

  bool _hasSeenStravaOnboarding = false;
  bool get hasSeenStravaOnboarding => _hasSeenStravaOnboarding;

  int get currentSteps => _currentSteps;
  int get goalSteps => _goalSteps;
  int? get goalTime => _goalTime;
  int? get goalDistance => _goalDistance;

  HomeController({required this.dinoController});

  final UserService _userService = UserService();
  final StreakService _streakService = StreakService();
  final PermissionService _permissionService = PermissionService();

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await _permissionService.requestAll();

    _healthService = HealthService();
    _healthService.stepsStream.listen((difference) async {
      if (difference > 0) {
        _currentSteps += difference;
        if (!dinoController.isStravaMode) {
          await dinoController.addSteps(difference);
        }
      } else {
        _currentSteps = _healthService.todaySteps;
      }
      _updateStreak();
      notifyListeners();
    });

    await _healthService.initialize();

    _currentSteps = _healthService.todaySteps;
    _updateStreak();
    notifyListeners();
  }

  Future<void> loadGoal() async {
    final prefs = await SharedPreferences.getInstance();

    isGoalSet = prefs.getBool('isGoalSet') ?? false;

    if (!isGoalSet) {
      final user = await _userService.getCurrentUser();
      if (user != null) {
        if (user.goalSteps != null) {
          await prefs.setInt('goalSteps', user.goalSteps!);
          await prefs.setBool('isGoalSet', true);
          isGoalSet = true;
        }

        if (user.goalTime != null) {
          await prefs.setInt('goalTime', user.goalTime!);
        }
        if (user.goalDistance != null) {
          await prefs.setInt('goalDistance', user.goalDistance!);
        }
        _hasSeenStravaOnboarding = user.hasSeenStravaOnboarding;
        await prefs.setBool('hasSeenStravaOnboarding', _hasSeenStravaOnboarding);
      }
    }

    if (isGoalSet) {
      _goalSteps = prefs.getInt('goalSteps') ?? 10000;
      _goalTime = prefs.getInt('goalTime');
      _goalDistance = prefs.getInt('goalDistance');
      _hasSeenStravaOnboarding = prefs.getBool('hasSeenStravaOnboarding') ?? false;
    }

    _streak = await _streakService.checkAndIncrementStreak(_currentSteps, _goalSteps);

    isLoadingGoal = false;
    notifyListeners();
  }

  Future<void> completeStravaOnboarding() async {
    _hasSeenStravaOnboarding = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenStravaOnboarding', true);
    _userService.updateHasSeenStravaOnboarding(_hasSeenStravaOnboarding);
  }

  Future<void> _updateStreak() async {
    final newStreak = await _streakService.checkAndIncrementStreak(_currentSteps, _goalSteps);
    if (newStreak != _streak) {
      _streak = newStreak;
      notifyListeners();
    }
  }

  Future<void> updateGoalSteps(int newGoal) async {
    _goalSteps = newGoal;
    isGoalSet = true;
    notifyListeners();

    _userService.updateGoalSteps(newGoal);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('goalSteps', newGoal);
    await prefs.setBool('isGoalSet', true);

    _updateStreak();
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

  Future<void> addSteps(int steps) async {
    await dinoController.addSteps(steps);
    notifyListeners();
  }

  Future<void> refreshSteps() async {
    if (!_isInitialized) return;
    await _healthService.refreshNow();
    _currentSteps = _healthService.todaySteps;
    _updateStreak();
    notifyListeners();
  }

  @override
  void dispose() {
    _healthService.dispose();
    super.dispose();
  }
}