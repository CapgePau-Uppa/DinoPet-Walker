import 'package:dinopet_walker/services/AuthService.dart';
import 'package:dinopet_walker/utils/Validator.dart';

class LoginController {
  final AuthService _authService = AuthService();

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;

    final emailError = Validator.email(email);
    if (emailError != null) return emailError;

    final passwordError = Validator.password(password);
    if (passwordError != null) return passwordError;

    try {
      await _authService.login(email: email, password: password);
      return null;
    } catch (e) {
      return "Email ou mot de passe incorrect";
    }
  }

  Future<String?> loginWithGoogle() async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;

    try {
      final result = await _authService.signInWithGoogle();
      return result == null ? "Connexion Google annulée" : null;
    } catch (e) {
      return "Erreur Google: ${e.toString()}";
    }
  }

  Future<String?> loginWithApple() async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;

    try {
      final result = await _authService.signInWithApple();
      if (result == null) {
        return "Apple Sign-In n'est disponible que sur iOS";
      }
      return null;
    } catch (e) {
      return "Erreur Apple: ${e.toString()}";
    }
  }
}
