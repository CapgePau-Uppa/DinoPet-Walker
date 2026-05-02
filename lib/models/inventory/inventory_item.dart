import 'package:flutter/material.dart';

enum ItemType { food, accessory, trophy }

enum ItemRarity { common, rare, epic }

abstract class InventoryItem {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemRarity rarity;
  final String emoji;
  final DateTime acquiredAt;
  final bool isUnlocked;
  final String unlockCondition;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.emoji,
    DateTime? acquiredAt,
    this.isUnlocked = true,
    this.unlockCondition = '',
  }) : acquiredAt = acquiredAt ?? DateTime.now();

  Color getRarityColor() {
    switch (rarity) {
      case ItemRarity.common:
        return const Color(0xFF757575); // Gris
      case ItemRarity.rare:
        return const Color(0xFF2196F3); // Bleu
      case ItemRarity.epic:
        return const Color(0xFF9C27B0); // Violet
    }
  }

  String getRarityLabel() {
    switch (rarity) {
      case ItemRarity.common:
        return 'Courant';
      case ItemRarity.rare:
        return 'Rare';
      case ItemRarity.epic:
        return 'Épique';
    }
  }

  Map<String, dynamic> toFirestore();
}
