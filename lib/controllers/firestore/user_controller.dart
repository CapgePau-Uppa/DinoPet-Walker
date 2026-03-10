import 'package:dinopet_walker/models/user_model.dart';
import 'package:dinopet_walker/services/user_service.dart';
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

  String get username => user?.username ?? '';
}
