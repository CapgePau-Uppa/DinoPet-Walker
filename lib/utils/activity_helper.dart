import 'package:flutter/material.dart';

class ActivityHelper {
  static String getSportName(String type) {
    switch (type) {
      case 'Walk':
        return 'Marche';
      case 'Run':
      case 'TrailRun':
        return 'Course à pied';
      case 'Ride':
      case 'EBikeRide':
        return 'Vélo';
      case 'MountainBikeRide':
        return 'VTT';
      case 'Swim':
        return 'Natation';
      case 'Hike':
        return 'Randonnée';
      case 'Workout':
      case 'HighIntensityIntervalTraining':
        return 'HIIT';
      case 'Yoga':
        return 'Yoga';
      case 'Pilates':
        return 'Pilates';
      case 'AlpineSki':
      case 'BackcountrySki':
      case 'NordicSki':
        return 'Ski';
      case 'Snowboard':
        return 'Snowboard';
      default:
        return 'Activité';
    }
  }

  static IconData getIconForSport(String sportName) {
    switch (sportName) {
      case 'Marche':
        return Icons.directions_walk;
      case 'Course à pied':
        return Icons.directions_run;
      case 'Vélo':
      case 'VTT':
        return Icons.directions_bike;
      case 'Natation':
        return Icons.pool;
      case 'Randonnée':
        return Icons.hiking;
      case 'HIIT':
        return Icons.fitness_center;
      case 'Pilates':
      case 'Yoga':
        return Icons.self_improvement;
      case 'Ski':
        return Icons.downhill_skiing;
      case 'Snowboard':
        return Icons.snowboarding;
      default:
        return Icons.star;
    }
  }
  
}
