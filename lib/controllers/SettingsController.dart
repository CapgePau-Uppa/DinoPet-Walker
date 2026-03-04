import 'package:dinopet_walker/services/AuthService.dart';

class SettingsController {
  final AuthService _authService = AuthService();

  Future<String?> signOut() async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;

    try {
      await _authService.signOut();
      return null;
    } catch (e) {
      return "Connexion requise";
    }
  }
}
