import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinopet_walker/models/user/user_model.dart';
import 'package:dinopet_walker/services/auth_service.dart';
import 'package:latlong2/latlong.dart';

class LocationSharingService {
  final _firestore = FirebaseFirestore.instance;
  final _authService = AuthService();

  String? get _uid => _authService.getCurrentUser()?.uid;

  // Publier sa position et son nombre de pas journalier dans Firestore
  Future<void> publishPositionAndCurrentSteps({
    required LatLng position,
    required int dailySteps,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).update({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'dailySteps': dailySteps,
      'locationUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Écouter les utilisateurs actifs druant la journée (ceux qui ont fait au moins un pas )
  Stream<List<UserModel>> watchOtherUsers() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();

    final startOfDay = Timestamp.fromDate(
      DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0),
    );

    return _firestore
        .collection('users')
        .where('locationUpdatedAt', isGreaterThan: startOfDay)
        .snapshots()
        .map(
          (snap) => snap.docs
              .where((doc) => doc.id != uid)
              .where((doc) {
                final data = doc.data();
                return data['latitude'] != null && data['longitude'] != null;
              })
              .map((doc) => UserModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

}
