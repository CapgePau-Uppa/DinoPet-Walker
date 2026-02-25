import 'package:dinopet_walker/models/DinoPet.dart';
import 'package:flutter/material.dart';

class DinoController extends ChangeNotifier {
  DinoPet? _dinoPet;
  DinoPet? get dinoPet => _dinoPet;

  void initializeDinoPet(DinoPet newDino) {
    _dinoPet = newDino;
    notifyListeners();
  }

  void addSteps(int steps) {
    if (_dinoPet == null) return;
    _dinoPet!.addSteps(steps);
    notifyListeners();
  }
}
