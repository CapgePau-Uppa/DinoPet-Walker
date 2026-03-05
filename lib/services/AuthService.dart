import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;

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

    return userCred;
  }

  // envoyer l'email de rénitialisation
  Future<String?> sendPasswordResetEmail({required String email}) async {
    try {
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://dinopetwalker.web.app',
        handleCodeInApp: true,
        androidPackageName: 'com.capgemini.dinopet', 
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseInstance.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      // Apple Sign-In only available on iOS
      if (!Platform.isIOS) {
        return null;
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      return await _firebaseInstance.signInWithCredential(oauthCredential);
    } catch (e) {
      return null;
    }
  }

}
