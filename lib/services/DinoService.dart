import 'package:dinopet_walker/models/DinoType.dart';

import '../models/DinoPet.dart';

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
