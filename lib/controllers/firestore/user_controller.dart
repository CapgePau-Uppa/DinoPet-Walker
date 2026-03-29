import 'package:dinopet_walker/models/user_model.dart';
import 'package:dinopet_walker/services/user_service.dart';
import 'package:dinopet_walker/utils/validator.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final UserService _userService = UserService();

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

  String get username => user?.username ?? '';
  String get email => user?.email ?? '';

}
