import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventory_item.dart';

class AccessoryItem extends InventoryItem {
  final bool equipped;

  AccessoryItem({
    required super.id,
    required super.name,
    required super.description,
    required super.emoji,
    required super.rarity,
    this.equipped = false,
    super.acquiredAt,
  }) : super(type: ItemType.accessory);

  factory AccessoryItem.fromFirestore(String id, Map<String, dynamic> data) {
    return AccessoryItem(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      emoji: data['emoji'] as String? ?? '🎩',
      equipped: data['equipped'] as bool? ?? false,
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
      'equipped': equipped,
      'acquiredAt': Timestamp.fromDate(acquiredAt),
    };
  }
}
