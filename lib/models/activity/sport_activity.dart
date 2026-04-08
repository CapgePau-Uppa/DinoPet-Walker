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

  String get formattedDate => "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}