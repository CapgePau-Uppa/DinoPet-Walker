class SportActivity {
  final String id;
  final String type;
  final double distanceInKm;
  final int durationInMinutes;
  final DateTime date;

  SportActivity({
    required this.id,
    required this.type,
    required this.distanceInKm,
    required this.durationInMinutes,
    required this.date,
  });

  String get sportName {
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

  String get formattedDate => "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}