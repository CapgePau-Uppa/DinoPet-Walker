import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinopet_walker/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  // Récupérer l'utilisateur authentifié a partir du quel on va créer l'utilisateur sur firestore
  User? getCurrentAthenticatedUser() {
    return _authInstance.currentUser;
  }

  Future<void> getOrCreateUserOnFirestore() async {
    final currentUser = getCurrentAthenticatedUser();

    if (currentUser == null) return;

    final user = await _firestoreInstance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    // s'il existe on ne fait rien
    if (user.exists) return; 

    final userModel = UserModel(
      uid: currentUser.uid,
      username: currentUser.displayName ?? currentUser.email!.split('@')[0],
      email: currentUser.email!,
    );
    // si non on le crée si c'est la première fois qu'il se connecte
    await _firestoreInstance
        .collection('users')
        .doc(userModel.uid)
        .set(userModel.toFirestore());
  }

  Future<UserModel?> getCurrentUser() async {
    final uid = getCurrentAthenticatedUser()?.uid;

    if (uid == null) return null;

    final user = await _firestoreInstance.collection('users').doc(uid).get();
    if (user.data() == null) return null;

    return UserModel.fromFirestore(uid, user.data()!);
  }

  Future<void> updateGoalSteps(int newGoal) async {
    final uid = getCurrentAthenticatedUser()?.uid;
    if (uid == null) return;

    await _firestoreInstance.collection('users').doc(uid).update({
      'goalSteps': newGoal,
    });
  }

  // mettre a jour le nom d'utilisateur 
  Future<void> updateUsername(String newUsername) async {
    final uid = getCurrentAthenticatedUser()?.uid;
    if (uid == null) return;
    await _firestoreInstance.collection('users').doc(uid).update({
      'username': newUsername,
    });
  }
}