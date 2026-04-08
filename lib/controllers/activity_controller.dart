import 'package:flutter/material.dart';
import 'package:dinopet_walker/models/sport_activity.dart';
import 'package:dinopet_walker/services/strava_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ActivityController extends ChangeNotifier {
  final StravaService _stravaService = StravaService();
  final _storage = const FlutterSecureStorage();

  bool isLoading = true;

  bool _isStravaLinked = false;
  bool get isStravaLinked => _isStravaLinked;

  double _totalDistance = 0.0;
  double get totalDistance => _totalDistance;

  int _totalDuration = 0;
  int get totalDuration => _totalDuration;

  List<SportActivity> _activities = [];
  List<SportActivity> get activities => _activities;

  List<SportActivity> _todayActivities = [];
  List<SportActivity> get todayActivities => _todayActivities;

  List<int> _weekTimeData = List.filled(7, 0);
  List<int> get weekTimeData => _weekTimeData;

  List<double> _weekDistanceData = List.filled(7, 0.0);
  List<double> get weekDistanceData => _weekDistanceData;

  Future<void> loadActivities({DateTime? weekStart, bool forceRefresh = false}) async {
    isLoading = true;
    notifyListeners();

    String? token = await _storage.read(key: 'strava_access_token');
    _isStravaLinked = token != null;

    if (isStravaLinked) {
      final now = DateTime.now();
      final wStart = weekStart ?? now.subtract(Duration(days: now.weekday - 1));
      final weekStartDay = DateTime(wStart.year, wStart.month, wStart.day);

      _totalDistance = 0.0;
      _totalDuration = 0;

      _weekTimeData = List.filled(7, 0);
      _weekDistanceData = List.filled(7, 0.0);

      if (_activities.isEmpty || forceRefresh) {
        _activities = (await _stravaService.fetchActivities())
            .where((a) => a.type != 'Walk')
            .toList();
      }

      _todayActivities = activities.where(
            (a) =>
              a.date.year == now.year &&
              a.date.month == now.month &&
              a.date.day == now.day,
      ).toList();

      for (final acvt in activities) {
        final activityDay = DateTime(
          acvt.date.year,
          acvt.date.month,
          acvt.date.day,
        );
        final weekEndDay = weekStartDay.add(const Duration(days: 6));

        if (!activityDay.isBefore(weekStartDay) && !activityDay.isAfter(weekEndDay)) {
          int dayIndex = activityDay.difference(weekStartDay).inDays;

          if (dayIndex >= 0 && dayIndex < 7) {
            if (acvt.distanceInKm > 0) {
              _totalDistance += acvt.distanceInKm;
              _weekDistanceData[dayIndex] += acvt.distanceInKm;
            }
            if (acvt.durationInMinutes > 0) {
              _totalDuration += acvt.durationInMinutes;
              _weekTimeData[dayIndex] += acvt.durationInMinutes;
            }
          }
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }
}