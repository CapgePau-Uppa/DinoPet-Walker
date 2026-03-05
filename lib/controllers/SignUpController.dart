import 'package:dinopet_walker/services/AuthService.dart';
import 'package:dinopet_walker/utils/Validator.dart';

class SignUpController {
  final AuthService _authService = AuthService();

  Future<String?> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;

    final usernameError = Validator.username(username);
    if (usernameError != null) return usernameError;

    final emailError = Validator.email(email);
    if (emailError != null) return emailError;

    final passwordError = Validator.password(password);
    if (passwordError != null) return passwordError;

    final matchError = Validator.passwordsMatch(password, confirmPassword);
    if (matchError != null) return matchError;

    try {
      await _authService.signUp(
        email: email,
        password: password,
        username: username,
      );
      return null;
    } catch (e) {
      return "Erreur lors de l'inscription. L'email est peut-être déjà utilisé.";
    }
  }

  Future<String?> signUpWithGoogle() async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;

    try {
      final result = await _authService.signInWithGoogle();
      return result == null ? "Inscription Google annulée" : null;
    } catch (e) {
      return "Erreur Google: ${e.toString()}";
    }
  }

  Future<String?> signUpWithApple() async {
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
