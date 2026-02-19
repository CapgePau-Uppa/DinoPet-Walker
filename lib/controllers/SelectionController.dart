import 'package:dinopet_walker/data/dinoData.dart';
import 'package:dinopet_walker/models/DinoType.dart';
import 'package:flutter/material.dart';
import '../models/DinoPet.dart';
import '../services/DinoService.dart';

class SelectionController extends ChangeNotifier {
  int _indexSelectedDino = 0;

  int get getSelectedIndex => _indexSelectedDino;

  DinoType get selectedDinoType => availableDinos[_indexSelectedDino];

  void selectDino(int index) {
    if (_indexSelectedDino != index) {
      _indexSelectedDino = index;
      notifyListeners();
    }
  }

  DinoPet createSelectedDinoPet() {
    return DinoService.createNewDinoPet(selectedDinoType);
  }
}
