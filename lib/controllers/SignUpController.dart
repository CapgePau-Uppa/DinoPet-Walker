import 'package:dinopet_walker/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController {
  final AuthService _authService = AuthService();

  String? _isValidUsername(String name) {
    if(name.isEmpty){
      return "Nom requis";
    }
    return null;
  }

  String? _isValidPassword(String password) {
    if (password.isEmpty) {
      return "Mot de passe requis";
    }
    if (password.length < 6) {
      return "Le mot de passe doit contenir au moins 6 caractères";
    }
    return null;
  }

  String? _validateConfirmPassword(String p1, String p2) {
    final passwordError = _isValidPassword(p1);
    if (passwordError != null) return passwordError;

    if (p1 != p2) return "Les mots de passe ne correspondent pas";
    return null;
  }

  Future<String?> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;
    
    final usernameError=_isValidUsername(username);
    if(usernameError !=null) return usernameError;

    final passwordError = _validateConfirmPassword(password, confirmPassword);
    if (passwordError != null) return passwordError;

    try {
      UserCredential userCred = await _authService.signUp(
        email: email,
        password: password,
        username: username
      );

      return null;
    } catch (e) {
      return "Erreur lors de l'inscription. L'email est peut-être déjà utilisé.";
    }
  }
}
