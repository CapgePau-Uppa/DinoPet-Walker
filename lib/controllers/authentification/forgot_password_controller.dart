import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/utils/validator.dart';

class ForgotPasswordController {
  final AuthService _authService = AuthService();

  Future<String?> sendResetPasswordEmail({required String email}) async {
    final emailError = Validator.email(email);
    if (emailError != null) return emailError;

    return await _authService.sendPasswordResetEmail(email: email);
  }
}
