import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventory_item.dart';

class TrophyItem extends InventoryItem {
  final String achievement;
  final int progress;
  final int progressMax;

  TrophyItem({
    required super.id,
    required super.name,
    required super.description,
    required super.emoji,
    required super.rarity,
    required this.achievement,
    this.progress = 100,
    this.progressMax = 100,
    super.acquiredAt,
    super.isUnlocked,
    super.unlockCondition,
  }) : super(type: ItemType.trophy);

  factory TrophyItem.fromFirestore(String id, Map<String, dynamic> data) {
    // Map old rarity values (0-4) to new ones (0-2)
    int oldRarity = data['rarity'] as int? ?? 0;
    int newRarity;
    if (oldRarity <= 1) { // common or uncommon -> common
      newRarity = 0;
    } else if (oldRarity == 2) { // rare -> rare
      newRarity = 1;
    } else { // epic or legendary -> epic
      newRarity = 2;
    }
    
    return TrophyItem(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      emoji: data['emoji'] as String? ?? '🏆',
      achievement: data['achievement'] as String? ?? '',
      progress: data['progress'] as int? ?? 100,
      progressMax: data['progressMax'] as int? ?? 100,
      rarity: ItemRarity.values[newRarity],
      acquiredAt: (data['acquiredAt'] as Timestamp?)?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    // Map new rarity (0-2) to old values (0-4) for backward compatibility
    int rarityValue;
    switch (rarity) {
      case ItemRarity.common:
        rarityValue = 0;
        break;
      case ItemRarity.rare:
        rarityValue = 2;
        break;
      case ItemRarity.epic:
        rarityValue = 4;
        break;
    }
    
    return {
      'name': name,
      'description': description,
      'emoji': emoji,
      'type': type.index,
      'rarity': rarityValue,
      'achievement': achievement,
      'progress': progress,
      'progressMax': progressMax,
      'acquiredAt': Timestamp.fromDate(acquiredAt),
    };
  }
}
