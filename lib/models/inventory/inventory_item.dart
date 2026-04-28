import 'package:flutter/material.dart';

enum ItemType { food, accessory, trophy }

enum ItemRarity { common, uncommon, rare, epic, legendary }

abstract class InventoryItem {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemRarity rarity;
  final String emoji;
  final DateTime acquiredAt;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.emoji,
    DateTime? acquiredAt,
  }) : acquiredAt = acquiredAt ?? DateTime.now();

  Color getRarityColor() {
    switch (rarity) {
      case ItemRarity.common:
        return const Color(0xFF757575); // Gris
      case ItemRarity.uncommon:
        return const Color(0xFF4CAF50); // Vert
      case ItemRarity.rare:
        return const Color(0xFF2196F3); // Bleu
      case ItemRarity.epic:
        return const Color(0xFF9C27B0); // Violet
      case ItemRarity.legendary:
        return const Color(0xFFFF9800); // Orange
    }
  }

  String getRarityLabel() {
    switch (rarity) {
      case ItemRarity.common:
        return 'Courant';
      case ItemRarity.uncommon:
        return 'Peu courant';
      case ItemRarity.rare:
        return 'Rare';
      case ItemRarity.epic:
        return 'Épique';
      case ItemRarity.legendary:
        return 'Légendaire';
    }
  }

  Map<String, dynamic> toFirestore();
}
