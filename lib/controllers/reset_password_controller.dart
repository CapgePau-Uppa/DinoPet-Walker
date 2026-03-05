import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/utils/validator.dart';

class ResetPasswordController {
  final AuthService _authService = AuthService();

  Future<String?> confirmReset({
    required String oobCode,
    required String password,
    required String confirm,
  }) async {
    final connectivityError = await _authService.checkConnectivity();
    if (connectivityError != null) return connectivityError;

    final passwordError = Validator.password(password);
    if (passwordError != null) return passwordError;

    final matchError = Validator.passwordsMatch(password, confirm);
    if (matchError != null) return matchError;

    try {
      await _authService.confirmPasswordReset(
        oobCode: oobCode,
        newPassword: password,
      );
      return null;
    } catch (e) {
      return "Erreur lors de la réinitialisation";
    }
  }
}
