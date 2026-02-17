import '../models/DinoPet.dart';

class DinoService {
  static DinoPetInstance createNewDinoPet(
    DinoType type,{
    int level = 1,
    int currentSteps = 0,
    int dailyStepsGoal = 5000,
  }) {
    return DinoPetInstance(
      id: 'dino_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      level: level,
      currentSteps: currentSteps,
      dailyStepsGoal: dailyStepsGoal,
    );
  }

}
