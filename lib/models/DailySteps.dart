class DailySteps {
  final String date;
  final int steps;
  final DateTime timestamp;
  final int lastSensorValue;

  DailySteps({
    required this.date,
    required this.steps,
    required this.timestamp,
    this.lastSensorValue = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'steps': steps,
      'timestamp': timestamp.toIso8601String(),
      'last_sensor_value': lastSensorValue, 
    };
  }

  factory DailySteps.fromMap(Map<String, dynamic> map) {
    return DailySteps(
      date: map['date'],
      steps: map['steps'],
      timestamp: DateTime.parse(map['timestamp']),
      lastSensorValue: map['last_sensor_value'] ?? 0, 
    );
  }
}