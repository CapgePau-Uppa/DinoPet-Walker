class DailySteps{
  final String date;
  final int steps;
  final DateTime timestamp;
  DailySteps({required this.date, required this.steps, required this.timestamp,});

  Map<String,dynamic> toMap(){
    return({
      'date':date,
      'steps':steps,
      'timestamp':timestamp.toIso8601String()
    });
  }

  factory DailySteps.fromMap(Map<String, dynamic> map) {
    return DailySteps(
      date: map['date'],
      steps: map['steps'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

}