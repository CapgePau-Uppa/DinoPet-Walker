import 'package:dinopet_walker/models/dino_type.dart';

import '../models/dino_pet.dart';

class DinoService {
  static DinoPet createNewDinoPet(
    DinoType type, {
    int level = 1,
    int xpSteps = 0,
  }) {
    return DinoPet(
      id: 'dino_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      level: level,
      xpSteps: xpSteps
    );
  }

}
