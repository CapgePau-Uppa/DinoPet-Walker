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
  }) : super(type: ItemType.trophy);

  factory TrophyItem.fromFirestore(String id, Map<String, dynamic> data) {
    return TrophyItem(
      id: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      emoji: data['emoji'] as String? ?? '🏆',
      achievement: data['achievement'] as String? ?? '',
      progress: data['progress'] as int? ?? 100,
      progressMax: data['progressMax'] as int? ?? 100,
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
      'achievement': achievement,
      'progress': progress,
      'progressMax': progressMax,
      'acquiredAt': Timestamp.fromDate(acquiredAt),
    };
  }
}
