import 'package:flutter/material.dart';

class ThemeHelper {
  // Séléectionner le thème selon l'activitée dominante
  static BoxDecoration getBackgroundDecoration(String? sportType) {
    String assetPath = 'assets/images/dinos/backgrounds/default_theme.jpg';

    if (sportType != null) {
      switch (sportType) {
        case 'Swim':
          assetPath = 'assets/images/dinos/backgrounds/swimming_theme.jpg';
          break;

        case 'Run':
        case 'TrailRun':
          assetPath =
              'assets/images/dinos/backgrounds/running_and_trail_theme.jpg';
          break;

        case 'Ride':
        case 'EBikeRide':
        case 'MountainBikeRide':
          assetPath =
              'assets/images/dinos/backgrounds/mountain_biking_theme.jpg';
          break;

        case 'AlpineSki':
        case 'Snowboard':
        case 'BackcountrySki':
        case 'NordicSki':
          assetPath = 'assets/images/dinos/backgrounds/snow_ski_theme.jpg';
          break;
        case 'Yoga':
        case 'Pilates':
        case 'Workout':
        case 'HighIntensityIntervalTraining':
          assetPath = 'assets/images/dinos/backgrounds/yoga_workout_theme.jpg';
          break;

        case 'Hike':
        case 'Walk':
          assetPath = 'assets/images/dinos/backgrounds/hike_walk_theme.jpg';
          break;
      }
    }

    return BoxDecoration(
      image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover),
    );
  }
}
