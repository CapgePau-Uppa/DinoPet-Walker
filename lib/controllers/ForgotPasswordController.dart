import 'package:dinopet_walker/services/AuthService.dart';

class ForgotPasswordController {
  final AuthService _authService = AuthService();

  String? isValidEmail(String email) {
    if (email.isEmpty) return "L'email est requis";
    if (!email.contains('@')) return "Email invalide";
    return null;
  }

  Future<String?> sendResetPasswordEmail({required String email}) async {
    final emailError = isValidEmail(email);
    if (emailError != null) return emailError;
    return await _authService.sendPasswordResetEmail(email: email);
  }
}
