import 'package:dinopet_walker/models/inventory/food_item.dart';
import 'package:dinopet_walker/models/inventory/accessory_item.dart';
import 'package:dinopet_walker/models/inventory/trophy_item.dart';
import 'package:dinopet_walker/models/inventory/inventory_item.dart';

/// Catalogue complet de tous les items possibles (débloqués et verrouillés)
class InventoryCatalog {
  /// Tous les aliments possibles
  static final List<FoodItem> allFoodItems = [
    FoodItem(
      id: 'food_apple',
      name: 'Pomme',
      description: 'Nourriture saine et délicieuse',
      emoji: '🍎',
      rarity: ItemRarity.common,
      quantity: 0,
      xpBonus: 10,
      isUnlocked: false,
      unlockCondition: '5000 pas marchés',
    ),
    FoodItem(
      id: 'food_banana',
      name: 'Banane',
      description: 'Fruit énergétique',
      emoji: '🍌',
      rarity: ItemRarity.common,
      quantity: 0,
      xpBonus: 15,
      isUnlocked: false,
      unlockCondition: 'Atteindre objectif quotidien',
    ),
  ];

  /// Tous les accessoires possibles
  static final List<AccessoryItem> allAccessoryItems = [
    AccessoryItem(
      id: 'accessory_hat',
      name: 'Chapeau',
      description: 'Un chapeau à la mode',
      emoji: '🎩',
      rarity: ItemRarity.common,
      isUnlocked: false,
      unlockCondition: 'Atteindre Niveau 5',
    ),
    AccessoryItem(
      id: 'accessory_glasses',
      name: 'Lunettes',
      description: 'Des lunettes cool',
      emoji: '🕶️',
      rarity: ItemRarity.rare,
      isUnlocked: false,
      unlockCondition: 'Atteindre Niveau 10',
    ),
    AccessoryItem(
      id: 'accessory_costume',
      name: 'Costume Spécial',
      description: 'Un costume épique',
      emoji: '🎭',
      rarity: ItemRarity.epic,
      isUnlocked: false,
      unlockCondition: 'Atteindre Niveau 25',
    ),
  ];

  /// Tous les trophées possibles
  static final List<TrophyItem> allTrophyItems = [
    TrophyItem(
      id: 'trophy_regular',
      name: 'Régulier',
      description: 'Bravo pour ta constance!',
      emoji: '🔥',
      rarity: ItemRarity.rare,
      achievement: 'streak_7_days',
      isUnlocked: false,
      unlockCondition: 'Maintenir un streak de 7 jours',
    ),
    TrophyItem(
      id: 'trophy_marathoner',
      name: 'Marathonien',
      description: 'Tu es un vrai marathonien!',
      emoji: '🏃',
      rarity: ItemRarity.epic,
      achievement: 'walked_50km',
      isUnlocked: false,
      unlockCondition: '50 kilomètres marchés au total',
    ),
    TrophyItem(
      id: 'trophy_strava_athlete',
      name: 'Athlète Strava',
      description: 'Champion sur Strava!',
      emoji: '⭐',
      rarity: ItemRarity.epic,
      achievement: 'strava_activities_10',
      isUnlocked: false,
      unlockCondition: '10 activités Strava complétées',
    ),
  ];

  /// Obtenir tous les items (aliments + accessoires + trophées)
  static List<InventoryItem> getAllItems() {
    return [
      ...allFoodItems,
      ...allAccessoryItems,
      ...allTrophyItems,
    ];
  }

  /// Combiner les items débloqués avec le catalogue complet
  static List<InventoryItem> mergeWithUnlocked(
    List<FoodItem> unlockedFood,
    List<AccessoryItem> unlockedAccessories,
    List<TrophyItem> unlockedTrophies,
  ) {
    final result = <InventoryItem>[];

    // Traiter les aliments
    for (var catalogItem in allFoodItems) {
      final unlocked = unlockedFood.firstWhere(
        (item) => item.id == catalogItem.id,
        orElse: () => catalogItem,
      );
      result.add(
        FoodItem(
          id: catalogItem.id,
          name: catalogItem.name,
          description: catalogItem.description,
          emoji: catalogItem.emoji,
          rarity: catalogItem.rarity,
          quantity: (unlocked as FoodItem).quantity,
          xpBonus: (unlocked as FoodItem).xpBonus,
          acquiredAt: unlocked.acquiredAt,
          isUnlocked: unlocked.id == catalogItem.id && unlockedFood.any((item) => item.id == catalogItem.id),
          unlockCondition: catalogItem.unlockCondition,
        ),
      );
    }

    // Traiter les accessoires
    for (var catalogItem in allAccessoryItems) {
      final unlocked = unlockedAccessories.firstWhere(
        (item) => item.id == catalogItem.id,
        orElse: () => catalogItem,
      );
      result.add(
        AccessoryItem(
          id: catalogItem.id,
          name: catalogItem.name,
          description: catalogItem.description,
          emoji: catalogItem.emoji,
          rarity: catalogItem.rarity,
          equipped: (unlocked as AccessoryItem).equipped,
          acquiredAt: unlocked.acquiredAt,
          isUnlocked: unlocked.id == catalogItem.id && unlockedAccessories.any((item) => item.id == catalogItem.id),
          unlockCondition: catalogItem.unlockCondition,
        ),
      );
    }

    // Traiter les trophées
    for (var catalogItem in allTrophyItems) {
      final unlocked = unlockedTrophies.firstWhere(
        (item) => item.id == catalogItem.id,
        orElse: () => catalogItem,
      );
      result.add(
        TrophyItem(
          id: catalogItem.id,
          name: catalogItem.name,
          description: catalogItem.description,
          emoji: catalogItem.emoji,
          rarity: catalogItem.rarity,
          achievement: (unlocked as TrophyItem).achievement,
          progress: (unlocked as TrophyItem).progress,
          progressMax: (unlocked as TrophyItem).progressMax,
          acquiredAt: unlocked.acquiredAt,
          isUnlocked: unlocked.id == catalogItem.id && unlockedTrophies.any((item) => item.id == catalogItem.id),
          unlockCondition: catalogItem.unlockCondition,
        ),
      );
    }

    return result;
  }
}
