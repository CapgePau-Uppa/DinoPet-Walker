import 'package:flutter/material.dart';
import 'package:dinopet_walker/models/sport_activity.dart';
import 'package:dinopet_walker/services/strava_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ActivityController extends ChangeNotifier {
  final StravaService _stravaService = StravaService();
  final _storage = const FlutterSecureStorage();

  double _totalDistance = 0.0;
  int _totalDuration = 0;

  double get totalDistance => _totalDistance;
  int get totalDuration => _totalDuration;

  List<SportActivity> activities = [];
  bool isLoading = true;
  bool isStravaLinked = false;

  Future<void> loadActivities() async {
    isLoading = true;
    notifyListeners();

    String? token = await _storage.read(key: 'strava_access_token');
    isStravaLinked = token != null;

    if (isStravaLinked) {
      activities = (await _stravaService.fetchActivities()).where((a) => a.type != 'Walk').toList();

      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));

      _totalDistance = 0.0;
      _totalDuration = 0;

      for (final acvt in activities) {
        final activityDay = DateTime(acvt.date.year, acvt.date.month, acvt.date.day);
        final weekStartDay = DateTime(weekStart.year,weekStart.month,weekStart.day,);
        if (!activityDay.isBefore(weekStartDay)) {
          if (acvt.distanceInKm > 0){
            _totalDistance += acvt.distanceInKm;
          } 
          if (acvt.durationInMinutes > 0){
            _totalDuration += acvt.durationInMinutes;
          }  
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }
}