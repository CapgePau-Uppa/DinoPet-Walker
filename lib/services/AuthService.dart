import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _firebaseInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

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
}
