import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? phone;
  final bool hasSeenStravaOnboarding;
  final int? goalSteps;
  final int? goalTime;
  final int? goalDistance;
  final int? streak;
  final String? lastStreakUpdate;
  final DateTime? createdAt;
  final String? dinoPetId; 
  final double? latitude;
  final double? longitude;
  final int? dailySteps;
  final DateTime? locationUpdatedAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.phone,
    this.hasSeenStravaOnboarding = false,
    this.goalSteps,
    this.goalTime,
    this.goalDistance,
    this.streak,
    this.lastStreakUpdate,
    this.createdAt,
    this.dinoPetId,
    this.latitude,
    this.longitude,
    this.dailySteps,
    this.locationUpdatedAt,
  });

  factory UserModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      hasSeenStravaOnboarding: data['hasSeenStravaOnboarding'] ?? false,
      goalSteps: data['goalSteps'] as int?,
      goalTime: data['goalTime'] as int?,
      goalDistance: data['goalDistance'] as int?,
      streak: data['streak'] as int?,
      lastStreakUpdate: data['lastStreakUpdate'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      dinoPetId: data['dinoPetId'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      dailySteps: data['dailySteps'] as int?,
      locationUpdatedAt: (data['locationUpdatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'hasSeenStravaOnboarding': hasSeenStravaOnboarding,
      'goalSteps': goalSteps,
      'goalTime': goalTime,
      'goalDistance': goalDistance,
      'streak': streak,
      'lastStreakUpdate': lastStreakUpdate,
      'createdAt': FieldValue.serverTimestamp(),
      if (dinoPetId != null) 'dinoPetId': dinoPetId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (dailySteps != null) 'dailySteps': dailySteps,
      if (locationUpdatedAt != null)
        'locationUpdatedAt': FieldValue.serverTimestamp(),
    };
  }
}
