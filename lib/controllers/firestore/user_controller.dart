import 'package:dinopet_walker/models/user_model.dart';
import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/services/user_service.dart';
import 'package:dinopet_walker/utils/validator.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  UserModel? user;

  // Récuperer ou créer l'utilisateur qui a validé son email sur firestore
  Future<void> getOrCreateUserOnFirestore() async {
    await _userService.getOrCreateUserOnFirestore();
  }

  // Récupération du username
  Future<void> getCurrentUser() async {
    user = await _userService.getCurrentUser();
    notifyListeners();
  }

  // Mettre a jour le username
  Future<String?> updateUsername(String newUsername) async {
    final error = Validator.username(newUsername);
    if (error != null) return error;

    if (newUsername.trim() == user?.username) {
      return "C'est déjà votre nom d'utilisateur";
    }

    await _userService.updateUsername(newUsername.trim());
    if (user != null) {
      user = UserModel(
        uid: user!.uid,
        username: newUsername.trim(),
        email: user!.email,
        goalSteps: user!.goalSteps,
        createdAt: user!.createdAt,
      );
      notifyListeners();
    }

    return null;
  }

  Future<String?> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    // récuperer  l'email courrant depuis Firestore 
    final currentEmail = await _userService.getCurrentUserEmail();
    if (currentEmail == null) return "Utilisateur introuvable";

    // réauthentifier avec l'email courrant
    final reauthError = await _authService.reauthenticate(
      email: currentEmail,
      password: password,
    );
    if (reauthError != null) return reauthError;

    // si tout est ok on envoie l'email de validation par email
    return await _authService.sendEmailUpdateVerification(newEmail: newEmail);
  }

  String get username => user?.username ?? '';
  String get email => user?.email ?? '';
  bool get isLoggedIn => _authService.getCurrentUser() != null;

}
