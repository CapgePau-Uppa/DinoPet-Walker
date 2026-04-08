import 'package:dinopet_walker/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/strava_service.dart';

class SettingsController {
  final _storage = const FlutterSecureStorage();
  final StravaService _stravaService = StravaService();
  final AuthService _authService = AuthService();

  Future<String?> signOut() async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;

    try {
      await _authService.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('goalSteps');
      await prefs.remove('isGoalSet');
      await prefs.remove('streak');
      await prefs.remove('lastStreakUpdate');
      return null;
    } catch (e) {
      return "Connexion requise";
    }
  }

  Future<bool> isStravaLinked() async {
    String? token = await _storage.read(key: 'strava_access_token');
    return token != null;
  }

  Future<bool> linkStrava() async {
    try {
      bool success = await _stravaService.loginToStrava();
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<void> unlinkStrava() async {
    await _storage.delete(key: 'strava_access_token');
    await _storage.delete(key: 'strava_refresh_token');
    await _storage.delete(key: 'strava_expires_at');
  }
}
