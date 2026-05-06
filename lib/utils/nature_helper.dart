import 'package:dinopet_walker/models/dino/dino_nature.dart';

class NatureHelper {
  static Nature getNatureFromSportType(String? sportType) {
    if (sportType == null) return Nature.terrestre;

    switch (sportType) {
      case 'Swim':
        return Nature.aquatic;

      case 'Run':
      case 'TrailRun':
        return Nature.runner;

      case 'Ride':
      case 'EBikeRide':
      case 'MountainBikeRide':
        return Nature.cyclist;

      case 'AlpineSki':
      case 'Snowboard':
      case 'BackcountrySki':
      case 'NordicSki':
        return Nature.mountain;

      case 'Yoga':
      case 'Pilates':
      case 'Workout':
      case 'HighIntensityIntervalTraining':
        return Nature.warrior;

      case 'Hike':
      case 'Walk':
        return Nature.explorer;

      default:
        return Nature.terrestre;
    }
  }
}
