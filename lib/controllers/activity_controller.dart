import 'package:dinopet_walker/models/dino_nature.dart';
import 'package:dinopet_walker/utils/nature_helper.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/models/sport_activity.dart';
import 'package:dinopet_walker/services/strava_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ActivityController extends ChangeNotifier {
  final StravaService _stravaService = StravaService();
  final _storage = const FlutterSecureStorage();

  Nature get dinoNature => NatureHelper.getNatureFromSportType(dominantSport);

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

  String? get dominantSport {
    if (_activities.isEmpty) return null;

    final now = DateTime.now();

    // Début de semaine
    final weekStartDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    // Fin (dimanche)
    final weekEndDay = weekStartDay.add(const Duration(days: 6));

    final Map<String, double> scorePerSport = {};

    for (var act in _activities) {
      final activityDay = DateTime(act.date.year, act.date.month, act.date.day);

      // Filtrer les activitées de cette semaine
      if (!activityDay.isBefore(weekStartDay) &&
          !activityDay.isAfter(weekEndDay)) {
        // Score (temps + distance)
        double score = act.durationInMinutes.toDouble();

        // Les km * 10 pour leur donner plus de valeur
        if (act.distanceInKm > 0) {
          score += (act.distanceInKm * 10);
        }

        // Score total par type de sport
        scorePerSport[act.type] = (scorePerSport[act.type] ?? 0) + score;
      }
    }

    String? dominant;
    double maxScore = -1;

    // Séléectionner le sport avec un score maximum
    scorePerSport.forEach((type, score) {
      if (score > maxScore) {
        maxScore = score;
        dominant = type;
      }
    });

    return dominant;
  }

  Future<void> loadActivities({
    DateTime? weekStart,
    bool forceRefresh = false,
  }) async {
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

      _todayActivities = activities
          .where(
            (a) =>
                a.date.year == now.year &&
                a.date.month == now.month &&
                a.date.day == now.day,
          )
          .toList();

      for (final acvt in activities) {
        final activityDay = DateTime(
          acvt.date.year,
          acvt.date.month,
          acvt.date.day,
        );
        final weekEndDay = weekStartDay.add(const Duration(days: 6));

        if (!activityDay.isBefore(weekStartDay) &&
            !activityDay.isAfter(weekEndDay)) {
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
