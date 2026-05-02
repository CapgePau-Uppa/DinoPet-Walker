class TrackPoint {
  final int? id;
  final String uid;
  final String date;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  TrackPoint({
    this.id,
    required this.uid,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'date': date,
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
  };

  factory TrackPoint.fromMap(Map<String, dynamic> map) => TrackPoint(
    id: map['id'] as int?,
    uid: map['uid'] as String,
    date: map['date'] as String,
    latitude: map['latitude'] as double,
    longitude: map['longitude'] as double,
    timestamp: DateTime.parse(map['timestamp'] as String),
  );
}
