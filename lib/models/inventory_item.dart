import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final DateTime? createdAt;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.createdAt,
  });

  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return InventoryItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      iconName: data['iconName'] ?? 'help_outline',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}