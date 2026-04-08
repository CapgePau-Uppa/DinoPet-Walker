import 'package:dinopet_walker/data/dino_data.dart';
import 'package:dinopet_walker/models/dino_type.dart';
import 'package:flutter/material.dart';
import '../models/dino_pet.dart';
import '../services/dino_service.dart';

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
