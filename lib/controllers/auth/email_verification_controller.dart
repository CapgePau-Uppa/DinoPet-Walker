import 'package:dinopet_walker/services/auth_service.dart';

class EmailVerificationController {
  final AuthService _authService = AuthService();

  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      /* Firebase empeche l'envoi de plusieurs emails au meme moment donc si l'utilisateur retombe une fois sur le screen 
      email verification une exception sera déclenchée mais on ne va pas la traiter*/
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

}
