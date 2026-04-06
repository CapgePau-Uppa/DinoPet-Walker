import 'package:dinopet_walker/models/dino_pet.dart';
import 'package:dinopet_walker/models/dino_type.dart';
import 'package:dinopet_walker/services/dino_service.dart';
import 'package:flutter/material.dart';

class DinoController extends ChangeNotifier {
  DinoPet? _dinoPet;
  DinoPet? get dinoPet => _dinoPet;

  bool isLoading = true;

  final DinoPetService _dinoPetService = DinoPetService();

  // Créer l'objet dino et le sauvegarder sur Firestore pour la prémière fois
  Future<void> initializeAndSave(DinoType type) async {
    _dinoPet = _dinoPetService.createNewDinoPet(type);
    notifyListeners();
    await _dinoPetService.saveDinoPet(_dinoPet!);
  }

  // Charger le dino depuis Firestore
  Future<void> loadDinoPet() async {
    isLoading = true;
    notifyListeners();

    _dinoPet = await _dinoPetService.loadDinoPet();

    isLoading = false;
    notifyListeners();
  }

  void addSteps(int steps) {
    if (_dinoPet == null) return;
    _dinoPet!.addSteps(steps);
    notifyListeners();
  }

  void resetDino() {
    if (_dinoPet == null) return;
    _dinoPet!.level = 1;
    _dinoPet!.xpSteps = 0;
    notifyListeners();
  }
}
