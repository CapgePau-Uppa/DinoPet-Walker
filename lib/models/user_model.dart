import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? phone;
  final int? goalSteps;
  final int? goalTime;
  final int? goalDistance;
  final int? streak;
  final String? lastStreakUpdate;
  final DateTime? createdAt;
  final String? dinoPetId; 

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.phone,
    this.goalSteps,
    this.goalTime,
    this.goalDistance,
    this.streak,
    this.lastStreakUpdate,
    this.createdAt,
    this.dinoPetId,
  });

  factory UserModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      goalSteps: data['goalSteps'] as int?,
      goalTime: data['goalTime'] as int?,
      goalDistance: data['goalDistance'] as int?,
      streak: data['streak'] as int?,
      lastStreakUpdate: data['lastStreakUpdate'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      dinoPetId: data['dinoPetId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'goalSteps': goalSteps,
      'goalTime': goalTime,
      'goalDistance': goalDistance,
      'streak': streak,
      'lastStreakUpdate': lastStreakUpdate,
      'createdAt': FieldValue.serverTimestamp(),
      if (dinoPetId != null) 'dinoPetId': dinoPetId,
    };
  }
}
