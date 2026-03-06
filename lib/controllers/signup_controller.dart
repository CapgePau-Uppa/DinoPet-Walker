import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/utils/validator.dart';

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

      await _authService.signOut();
      
      return null;
    } catch (e) {
      return "Erreur lors de l'inscription.\nL'email est peut-être déjà utilisé.";
    }
  }

}
