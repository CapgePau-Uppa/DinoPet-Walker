import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/utils/validator.dart';

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
}
