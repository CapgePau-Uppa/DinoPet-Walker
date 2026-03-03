import 'package:dinopet_walker/services/AuthService.dart';

class LoginController {
  final AuthService _authService = AuthService();

  String? isValidEmail(String email){
    if (email.isEmpty) return "L'email est requis";
    if (!email.contains('@')) return "Email invalide";
    return null;
  }

  String? isValidPassword(String password) {
    if (password.isEmpty) return "Le mot de passe est requis";
    if (password.length < 6) return "Minimum 6 caractères";
    return null;
  }

  Future <String?> login({required String email,required String password}) async {
    final emailError = isValidEmail(email);
    if (emailError != null) return emailError;

    final passwordError = isValidPassword(password);
    if (passwordError != null) return passwordError;

    try {
      await _authService.login(email: email, password: password);
      return null; 
    } catch (e) {
      return "Email ou mot de passe incorect";
    }
  }
}