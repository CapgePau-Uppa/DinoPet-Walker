import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/utils/validator.dart';

class ChangePasswordController {
  final AuthService _authService = AuthService();

  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final user = _authService.getCurrentUser()!;

    final oldError = Validator.password(oldPassword);
    if (oldError != null) return oldError;

    final newError = Validator.password(newPassword);
    if (newError != null) return newError;

    final matchError = Validator.passwordsMatch(newPassword, confirmPassword);
    if (matchError != null) return matchError;

    if (oldPassword == newPassword) {
      return "Le nouveau mot de passe doit être différent de l'ancien !";
    }

    return await _authService.changePassword(
      email: user.email!,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
