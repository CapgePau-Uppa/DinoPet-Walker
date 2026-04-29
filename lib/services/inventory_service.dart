import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getInventoryPage(String userId, int limit, {DocumentSnapshot? startAt}) {
    var query = _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAt != null) {
      query = query.startAtDocument(startAt);
    }

    return query.get();
  }
}