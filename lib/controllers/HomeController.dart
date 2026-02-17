import 'dart:async';
import 'package:dinopet_walker/services/PedometerService.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends ChangeNotifier {
  late PedometerService _pedometerService;

  int currentSteps = 0;
  int userLevel = 10;
  final int goalSteps = 10000;

  StreamSubscription<int>? _stepsSubscription;
  bool _isInitialized = false;// on initialise le controlleur qu'une seule fois

  Future<void> init() async {
    if (_isInitialized) return; 

    _pedometerService = PedometerService();

    //demander les permessions
    await Permission.activityRecognition.request();
    await Permission.notification.request();

    // pour ignorer exempter l'app de l'optimisation de batterie
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    _initService();
    _isInitialized = true;
  }

  void _initService() {
    Future(() async {
      await _pedometerService.initialize();

      currentSteps = _pedometerService.todaySteps;
      notifyListeners();

      // Écouter les mises à jour des pas
      _stepsSubscription = _pedometerService.stepsStream.listen((steps) {
        currentSteps = steps;
        notifyListeners();
      });
    });
  }


  void increaseLevel() {
    userLevel += 5;
    notifyListeners();
  }

  void decreaseLevel() {
    if (userLevel > 5) {
      userLevel -= 5;
      notifyListeners();
    }
  }

  Future<void> stopService() async {
    await _pedometerService.stopService();
  }

  @override
  void dispose() {
    _stepsSubscription?.cancel();
    _pedometerService.dispose();
    super.dispose();
  }
}
