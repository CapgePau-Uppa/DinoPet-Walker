import 'package:dinopet_walker/data/dino_data.dart';
import 'package:dinopet_walker/models/dino/dino_type.dart';
import 'package:dinopet_walker/services/dino_service.dart';
import 'package:flutter/material.dart';
import '../models/dino/dino_pet.dart';

class SelectionController extends ChangeNotifier {
  int _indexSelectedDino = 0;
  final DinoPetService _dinoPetService = DinoPetService();

  int get getSelectedIndex => _indexSelectedDino;
  DinoType get selectedDinoType => availableDinos[_indexSelectedDino];

  void selectDino(int index) {
    if (_indexSelectedDino != index) {
      _indexSelectedDino = index;
      notifyListeners();
    }
  }

  DinoPet createSelectedDinoPet() {
    return _dinoPetService.createNewDinoPet(selectedDinoType);
  }
}
