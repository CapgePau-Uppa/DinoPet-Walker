import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/sport_activity.dart';

class StravaService {
  final String clientId = '207948';
  final String clientSecret = 'd5cdff7f7fec1a123e4dc95153b15712a11b59ea';

  final String redirectUri = 'dinopet://dinopet.app';

  final _storage = const FlutterSecureStorage();

  Future<bool> loginToStrava() async {
    final url = 'https://www.strava.com/oauth/mobile/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&approval_prompt=auto&scope=activity:read_all';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'dinopet',
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code != null) {
        return await _exchangeCodeForToken(code);
      }
      return false;
    } catch (e) {
      print('Erreur de connexion Strava: $e');
      return false;
    }
  }

  Future<bool> _exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse('https://www.strava.com/oauth/token'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'grant_type': 'authorization_code',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await _storage.write(key: 'strava_access_token', value: data['access_token']);
      await _storage.write(key: 'strava_refresh_token', value: data['refresh_token']);
      await _storage.write(key: 'strava_expires_at', value: data['expires_at'].toString());

      return true;
    } else {
      return false;
    }
  }

  Future<List<SportActivity>> fetchActivities() async {
    String? token = await _storage.read(key: 'strava_access_token');
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('https://www.strava.com/api/v3/athlete/activities'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List rawActivities = jsonDecode(response.body);

      final List<String> sportsAutorises = [
        'Walk',
        'Run',
        'TrailRun',
        'Ride',
        'MountainBikeRide',
        'EBikeRide',
        'Swim',
        'Hike',
        'Workout',
        'HighIntensityIntervalTraining',
        'Yoga',
        'Pilates',
        'AlpineSki',
        'Snowboard',
        'BackcountrySki',
        'NordicSki'
      ];

      final filteredActivities = rawActivities.where((json) {
        return sportsAutorises.contains(json['type']);
      }).toList();

      return filteredActivities.map((json) {
        return SportActivity(
          id: json['id'].toString(),
          type: json['type'],
          distanceInKm: json['distance'] / 1000,
          durationInMinutes: json['moving_time'] ~/ 60,
          date: DateTime.parse(json['start_date']),
        );
      }).toList();
    }
    return [];
  }
}