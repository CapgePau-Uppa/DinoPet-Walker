import 'package:dinopet_walker/services/AuthService.dart';
import 'package:dinopet_walker/utils/Validator.dart';

class ForgotPasswordController {
  final AuthService _authService = AuthService();

  Future<String?> sendResetPasswordEmail({required String email}) async {
    final emailError = Validator.email(email);
    if (emailError != null) return emailError;

    return await _authService.sendPasswordResetEmail(email: email);
  }
}
