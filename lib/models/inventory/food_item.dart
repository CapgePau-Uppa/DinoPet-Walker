import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventory_item.dart';

class FoodItem extends InventoryItem {
  final int quantity;
  final int xpBonus;

  FoodItem({
    required super.id,
    required super.name,
    required super.description,
    required super.emoji,
    required super.rarity,
    required this.quantity,
    required this.xpBonus,
    super.acquiredAt,
  }) : super(type: ItemType.food);

  factory FoodItem.fromFirestore(String id, Map<String, dynamic> data) {
    return FoodItem(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      emoji: data['emoji'] as String? ?? '🍎',
      quantity: data['quantity'] as int? ?? 0,
      xpBonus: data['xpBonus'] as int? ?? 10,
      rarity: ItemRarity.values[data['rarity'] as int? ?? 0],
      acquiredAt: (data['acquiredAt'] as Timestamp?)?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'emoji': emoji,
      'type': type.index,
      'rarity': rarity.index,
      'quantity': quantity,
      'xpBonus': xpBonus,
      'acquiredAt': Timestamp.fromDate(acquiredAt),
    };
  }
}
