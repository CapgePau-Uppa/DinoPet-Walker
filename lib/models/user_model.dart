import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.createdAt,
  });

  // Récupérer un utilisateur de firestore et le convertir en objet dart 
  factory UserModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convertir un objet dart utilisateur en un document pour le stocker sur firestore
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
