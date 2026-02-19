import 'package:dinopet_walker/models/DinoPet.dart';
import 'package:dinopet_walker/models/LifeStage.dart';

class DinoAnimationConfig {
  static const double boxSize = 420.0;
  static const double baseCircle = 200.0;
  static const double imgRatioMin = 0.58;
  static const double imgRatioMax = 0.84;

  static const Map<LifeStage, List<int>> levelBounds = {
    LifeStage.baby: [1, 10],
    LifeStage.child: [11, 25],
    LifeStage.teenager: [26, 40],
    LifeStage.adult: [41, 50],
  };

  static const Map<LifeStage, double> circleScales = {
    LifeStage.baby: 1.00,
    LifeStage.child: 1.28,
    LifeStage.teenager: 1.40,
    LifeStage.adult: 1.50,
  };

  // calcule la taille du dino 
  static double imgRatioFor(LifeStage stage, int level) {
    final b = levelBounds[stage]!;
    final t = ((level - b[0]) / (b[1] - b[0])).clamp(0.0, 1.0);
    return imgRatioMin + t * (imgRatioMax - imgRatioMin);
  }

  // calcule la taille du cercle selon le stage et le niveau 
  static double circleRadiusFor(LifeStage stage, int level) {
    final b = levelBounds[stage]!;
    final t = ((level - b[0]) / (b[1] - b[0])).clamp(0.0, 1.0);

    final double minRadius = baseCircle * circleScales[stage]!;
    final nextStage = stage.nextStage;
    final double maxRadius = nextStage != null
        ? baseCircle * circleScales[nextStage]!
        : baseCircle * circleScales[stage]!;

    return minRadius + t * (maxRadius - minRadius);
  }
}
