import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/sport_activity.dart';

class StravaService {
  final String clientId = dotenv.env['STRAVA_CLIENT_ID']!;
  final String clientSecret = dotenv.env['STRAVA_CLIENT_SECRET']!;
  final String redirectUri = dotenv.env['STRAVA_REDIRECT_URI']!;

  // Pour sauvegarder les tokens
  final _storage = const FlutterSecureStorage();

  Future<bool> loginToStrava() async {
    try {
      await _storage.deleteAll();

      // Construire l'url d'autorisation
      final url =
          'https://www.strava.com/oauth/mobile/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&approval_prompt=auto&scope=activity:read_all';

      // Ouvrir un navigateur intégré avec la page de connexion strava puis intercepter l'url de redirection
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'dinopet',
      );

      // Extraire le code temporaire de l'url interceptée
      final code = Uri.parse(result).queryParameters['code'];

      if (code != null) {
        // Echanger le code par un token
        return await _exchangeCodeForToken(code);
      }
      return false;
    } catch (e) {
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
      await _saveToken(data);
      return true;
    }
    return false;
  }

  Future<void> _saveToken(Map<String, dynamic> data) async {
    // Sauvegarder le vrai token
    await _storage.write(
      key: 'strava_access_token',
      value: data['access_token'],
    );

    // Permet d'obtenir un nouveau token
    await _storage.write(
      key: 'strava_refresh_token',
      value: data['refresh_token'],
    );

    // Timestamp indiquant quand le token expire
    await _storage.write(
      key: 'strava_expires_at',
      value: data['expires_at'].toString(),
    );
  }

  Future<String?> _getToken() async {
    final accessToken = await _storage.read(key: 'strava_access_token');
    final refreshToken = await _storage.read(key: 'strava_refresh_token');
    final expiresAt = await _storage.read(key: 'strava_expires_at');

    // Un des tokens manque 
    if (accessToken == null || refreshToken == null || expiresAt == null) {
      return null;
    }
    // La date d'expiration en secondes (Unix Timestamp)
    final expires = int.tryParse(expiresAt) ?? 0;
    // Convertit l'heure actuelle en secondes (Unix Timestamp)
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000; // ~/ 1000 pour correspondre au format de Strava

    // Token encore valide 
    if (now < expires) {
      return accessToken;
    }

    // Token expiré on rafraîchit
    final success = await _refreshToken(refreshToken);
    if (!success) {
      // On nettoie tout pour forcer une reconnexion
      await _storage.deleteAll();
      return null;
    }

    return await _storage.read(key: 'strava_access_token');
  }

  Future<bool> _refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://www.strava.com/oauth/token'),
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Récupérer les activiés de Strava 
  Future<List<SportActivity>> fetchActivities() async {
    String? token = await _getToken();
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
        'NordicSki',
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

    // Token refusé 
    if (response.statusCode == 401) {
      await _storage.deleteAll();
    }

    return [];
  }
}
