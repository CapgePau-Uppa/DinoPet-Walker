import 'package:dinopet_walker/models/inventory/inventory_item.dart';
import 'package:flutter/material.dart';

class InventoryConstants {
  /// Couleurs de rareté
  static const Color rarityColorCommon = Color(0xFF757575);    // Gris
  static const Color rarityColorUncommon = Color(0xFF4CAF50);  // Vert
  static const Color rarityColorRare = Color(0xFF2196F3);      // Bleu
  static const Color rarityColorEpic = Color(0xFF9C27B0);      // Violet
  static const Color rarityColorLegendary = Color(0xFFFF9800); // Orange

  /// Nombre d'items par page
  static const int itemsPerPage = 10;

  /// Étiquettes de rareté
  static const Map<ItemRarity, String> rarityLabels = {
    ItemRarity.common: 'Courant',
    ItemRarity.uncommon: 'Peu courant',
    ItemRarity.rare: 'Rare',
    ItemRarity.epic: 'Épique',
    ItemRarity.legendary: 'Légendaire',
  };

  /// Noms des onglets
  static const List<String> tabNames = [
    '🍖 Nourriture',
    '🎁 Accessoires',
    '🏆 Trophées',
  ];

  /// Messages vides pour chaque onglet
  static const List<String> emptyMessages = [
    'Aucune nourriture',
    'Aucun accessoire',
    'Aucun trophée',
  ];

  /// Message d'aide
  static const String emptyHelpMessage =
      'Obtenez des items en atteignant vos objectifs !';
}
