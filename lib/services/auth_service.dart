import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;

  // récupérer l'utilisateur courrant
  User? getCurrentUser() {
    return _firebaseInstance.currentUser;
  }

  // verifier la connexion
  Future<String?> checkConnectivity() async {
    try {
      // connexion Wifi ou cellulaire
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      bool hasInternet = connectivityResult.contains(ConnectivityResult.wifi) ||
      connectivityResult.contains(ConnectivityResult.mobile) ;
      if (!hasInternet) {
        return "Connexion internet requise";
      }
      return null;
    } catch (e) {
      return "Impossible de vérifier la connexion";
    }
  }

  // se connecter
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _firebaseInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // s'inscrire
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final userCred= await _firebaseInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCred.user?.updateDisplayName(username);

    return userCred;
  }

  // Envoi email de confirmation 
  Future<void> sendEmailVerification() async {
    final user = _firebaseInstance.currentUser;

    if (user != null && !user.emailVerified) {
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://dinopetwalker.web.app',
        handleCodeInApp: true,
        iOSBundleId: 'com.example.dinopetWalker',
        androidPackageName: 'com.example.dinopet_walker',
        androidInstallApp: true,
        androidMinimumVersion: '21',
      );

      await user.sendEmailVerification(actionCodeSettings);
    }
  }

  // envoyer l'email de rénitialisation
  Future<String?> sendPasswordResetEmail({required String email}) async {
    try {
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://dinopetwalker.web.app', // le lien envoyé par email pointe sur ce domaine
        handleCodeInApp: true, // le lien doit etre traité dans l'app
        iOSBundleId: 'com.example.dinopetWalker',
        androidPackageName: 'com.example.dinopet_walker', 
        androidInstallApp: true, // propose d'installer l'app si elle n'est pas installé (plus tard)
        androidMinimumVersion: '21',
      );

      await _firebaseInstance.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // se déconnecter
  Future<void> signOut() async {
    await _firebaseInstance.signOut();
  }

  // confirmer le reset
  Future<void> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    await _firebaseInstance.confirmPasswordReset(
      code: oobCode,
      newPassword: newPassword,
    );
  }

  // envoyer un email de validation pour mettre a jour l'email de l'utilisateur
  Future<String?> sendEmailUpdateVerification({
    required String newEmail,
  }) async {
    try {
      final user = _firebaseInstance.currentUser;

      final actionCodeSettings = ActionCodeSettings(
        url:
            'https://dinopetwalker.web.app/?newEmail=${Uri.encodeComponent(newEmail)}',
        handleCodeInApp: true,
        androidPackageName: 'com.example.dinopet_walker',
        androidInstallApp: true,
        androidMinimumVersion: '21',
      );

      await user!.verifyBeforeUpdateEmail(newEmail, actionCodeSettings);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return "Veuillez vous reconnecter avant de changer votre email";
      }
      return e.message;
    }
  }
  
  // valider le code OOB reçu par email et rafraichit les données de l'utilisateur
  Future<void> verifyEmail(String oobCode) async {
    await _firebaseInstance.applyActionCode(oobCode);
    await _firebaseInstance.currentUser?.reload();
  }

  // appliquer le changement d'email et retourne le nouvel email extrait de l'url
  Future<String?> applyEmailChange({
    required String oobCode,
    required String? continueUrlRaw,
  }) async {
    String? newEmail;

    if (continueUrlRaw != null) {
      final decodedOnce = Uri.decodeComponent(continueUrlRaw);
      final parsedContinueUrl = Uri.tryParse(decodedOnce);
      newEmail = parsedContinueUrl?.queryParameters['newEmail'];
    }

    await _firebaseInstance.applyActionCode(oobCode);

    return newEmail;
  }

  // révoquer le code pour annuler le changement d'email
  Future<void> revokeEmailChange(String oobCode) async {
    await _firebaseInstance.checkActionCode(oobCode);
    // on applique pas le code, il expire naturellement
  }

  // réauthentifier l'utilisateur avec son mot de passe actuel
  Future<String?> reauthenticate({
    required String email,
    required String password,
  }) async {
    try {
      final user = _firebaseInstance.currentUser;
      if (user == null) return "Utilisateur introuvable";

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return "Mot de passe incorrect";
      }
      return e.message;
    }
  }
  
  // rénitialiser le mot de passe (pas besoin d'envoi d'email de validation)
  Future<String?> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = getCurrentUser()!;

      final credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return "Mot de passe incorrect";
      }

      return "Une erreur est survenue";
    }
  }

}
