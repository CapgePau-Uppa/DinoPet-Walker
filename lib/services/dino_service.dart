import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinopet_walker/models/dino/dino_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dinopet_walker/models/dino/dino_pet.dart';

class DinoPetService {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // Créer l'objet dino
  DinoPet createNewDinoPet(DinoType type, {int initialSteps = 0}) {
    final dino = DinoPet(id: _uid!,type: type,);
    if (initialSteps > 0) {
      dino.addXp(initialSteps);
    }
    return dino;
  }

  // Sauvegarder le dino sur Firestore
  Future<void> saveDinoPet(DinoPet dino) async {
    if (_uid == null) return;

    await _firestoreInstance
        .collection('dino_pets').doc(_uid).set(dino.toFirestore());

    await _firestoreInstance.collection('users').doc(_uid).update({
      'dinoPetId': _uid,
    });
  }

  // Charger le dino depuis Firestore 
  Future<DinoPet?> loadDinoPet() async {
    if (_uid == null) return null;

    final doc = await _firestoreInstance
        .collection('dino_pets').doc(_uid).get();
    if (!doc.exists || doc.data() == null) return null;

    return DinoPet.fromFirestore(doc.id, doc.data()!);
  }
}
