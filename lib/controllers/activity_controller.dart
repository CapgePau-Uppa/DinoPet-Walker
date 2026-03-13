import 'package:flutter/material.dart';
import 'package:dinopet_walker/models/sport_activity.dart';
import 'package:dinopet_walker/services/strava_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ActivityController extends ChangeNotifier {
  final StravaService _stravaService = StravaService();
  final _storage = const FlutterSecureStorage();

  List<SportActivity> activities = [];
  bool isLoading = true;
  bool isStravaLinked = false;

  Future<void> loadActivities() async {
    isLoading = true;
    notifyListeners();

    String? token = await _storage.read(key: 'strava_access_token');
    isStravaLinked = token != null;

    if (isStravaLinked) {
      activities = await _stravaService.fetchActivities();
    }

    isLoading = false;
    notifyListeners();
  }
}