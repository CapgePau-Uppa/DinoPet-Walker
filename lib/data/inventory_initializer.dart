import 'package:dinopet_walker/models/inventory/food_item.dart';
import 'package:dinopet_walker/models/inventory/accessory_item.dart';
import 'package:dinopet_walker/models/inventory/trophy_item.dart';
import 'package:dinopet_walker/models/inventory/inventory_item.dart';

class InventoryInitializer {
  /// Créer l'inventaire initial avec des items de base
  static Future<void> initializeInventoryForNewUser(
    String uid,
    Function(FoodItem) addFood,
    Function(AccessoryItem) addAccessory,
    Function(TrophyItem) addTrophy,
  ) async {
    // Items de nourriture initiaux
    final initialFoodItems = [
      FoodItem(
        id: 'apple_basic',
        name: 'Pomme',
        description: 'Une pomme juteuse et nutritive',
        emoji: '🍎',
        rarity: ItemRarity.common,
        quantity: 3,
        xpBonus: 50,
      ),
      FoodItem(
        id: 'banana_basic',
        name: 'Banane',
        description: 'Une banane énergétique',
        emoji: '🍌',
        rarity: ItemRarity.common,
        quantity: 2,
        xpBonus: 60,
      ),
      FoodItem(
        id: 'meat_basic',
        name: 'Viande',
        description: 'De la viande succulente',
        emoji: '🍖',
        rarity: ItemRarity.uncommon,
        quantity: 1,
        xpBonus: 100,
      ),
    ];

    // Accessoires initiaux
    final initialAccessories = [
      AccessoryItem(
        id: 'hat_basic',
        name: 'Chapeau Simple',
        description: 'Un chapeau confortable',
        emoji: '🎩',
        rarity: ItemRarity.common,
        equipped: false,
      ),
    ];

    // Trophées initiaux
    final initialTrophies = [
      TrophyItem(
        id: 'first_steps',
        name: 'Premiers Pas',
        description: 'Atteindre 1000 pas',
        emoji: '👣',
        rarity: ItemRarity.common,
        achievement: 'first_steps',
      ),
    ];

    // Ajouter tous les items
    for (var food in initialFoodItems) {
      await addFood(food);
    }
    for (var accessory in initialAccessories) {
      await addAccessory(accessory);
    }
    for (var trophy in initialTrophies) {
      await addTrophy(trophy);
    }
  }

  /// Obtenir un item de nourriture par type
  static FoodItem createFoodItem(String type) {
    final foods = {
      'apple': FoodItem(
        id: 'apple_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Pomme',
        description: 'Une pomme juteuse et nutritive',
        emoji: '🍎',
        rarity: ItemRarity.common,
        quantity: 1,
        xpBonus: 50,
      ),
      'banana': FoodItem(
        id: 'banana_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Banane',
        description: 'Une banane énergétique',
        emoji: '🍌',
        rarity: ItemRarity.common,
        quantity: 1,
        xpBonus: 60,
      ),
      'meat': FoodItem(
        id: 'meat_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Viande',
        description: 'De la viande succulente',
        emoji: '🍖',
        rarity: ItemRarity.uncommon,
        quantity: 1,
        xpBonus: 100,
      ),
      'orange': FoodItem(
        id: 'orange_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Orange',
        description: 'Une orange juteuse et vitaminée',
        emoji: '🍊',
        rarity: ItemRarity.common,
        quantity: 1,
        xpBonus: 55,
      ),
      'strawberry': FoodItem(
        id: 'strawberry_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Fraise',
        description: 'Une fraise sucrée',
        emoji: '🍓',
        rarity: ItemRarity.uncommon,
        quantity: 1,
        xpBonus: 75,
      ),
      'grapes': FoodItem(
        id: 'grapes_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Raisins',
        description: 'Des raisins délicieux',
        emoji: '🍇',
        rarity: ItemRarity.uncommon,
        quantity: 1,
        xpBonus: 70,
      ),
      'watermelon': FoodItem(
        id: 'watermelon_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Pastèque',
        description: 'Une pastèque rafraîchissante',
        emoji: '🍉',
        rarity: ItemRarity.rare,
        quantity: 1,
        xpBonus: 150,
      ),
      'cake': FoodItem(
        id: 'cake_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Gâteau',
        description: 'Un gâteau délicieux',
        emoji: '🍰',
        rarity: ItemRarity.epic,
        quantity: 1,
        xpBonus: 200,
      ),
    };

    return foods[type] ??
        FoodItem(
          id: 'unknown_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Nourriture inconnue',
          description: 'Un item inconnu',
          emoji: '❓',
          rarity: ItemRarity.common,
          quantity: 1,
          xpBonus: 0,
        );
  }

  /// Obtenir un accessoire par type
  static AccessoryItem createAccessoryItem(String type) {
    final accessories = {
      'hat': AccessoryItem(
        id: 'hat_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Chapeau Simple',
        description: 'Un chapeau confortable',
        emoji: '🎩',
        rarity: ItemRarity.common,
      ),
      'crown': AccessoryItem(
        id: 'crown_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Couronne',
        description: 'Une couronne royale',
        emoji: '👑',
        rarity: ItemRarity.rare,
      ),
      'glasses': AccessoryItem(
        id: 'glasses_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Lunettes de Soleil',
        description: 'Des lunettes cool',
        emoji: '😎',
        rarity: ItemRarity.uncommon,
      ),
      'bow': AccessoryItem(
        id: 'bow_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Nœud Papillon',
        description: 'Un nœud papillon élégant',
        emoji: '🎀',
        rarity: ItemRarity.uncommon,
      ),
      'flower_crown': AccessoryItem(
        id: 'flower_crown_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Couronne de Fleurs',
        description: 'Une couronne fleurie',
        emoji: '🌸',
        rarity: ItemRarity.epic,
      ),
    };

    return accessories[type] ??
        AccessoryItem(
          id: 'unknown_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Accessoire inconnu',
          description: 'Un item inconnu',
          emoji: '❓',
          rarity: ItemRarity.common,
        );
  }

  /// Obtenir un trophée par type
  static TrophyItem createTrophyItem(String type) {
    final trophies = {
      'first_steps': TrophyItem(
        id: 'first_steps_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Premiers Pas',
        description: 'Atteindre 1000 pas',
        emoji: '👣',
        rarity: ItemRarity.common,
        achievement: 'first_steps',
      ),
      'marathon': TrophyItem(
        id: 'marathon_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Marathonien',
        description: 'Parcourir 50 km',
        emoji: '🏃',
        rarity: ItemRarity.rare,
        achievement: 'marathon',
      ),
      'regular': TrophyItem(
        id: 'regular_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Régulier',
        description: 'Maintenir une série de 7 jours',
        emoji: '🔥',
        rarity: ItemRarity.rare,
        achievement: 'regular',
      ),
      'strava_master': TrophyItem(
        id: 'strava_master_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Maître Strava',
        description: 'Compléter 10 activités Strava',
        emoji: '⭐',
        rarity: ItemRarity.epic,
        achievement: 'strava_master',
      ),
      'level_10': TrophyItem(
        id: 'level_10_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Niveau 10',
        description: 'Atteindre le niveau 10',
        emoji: '📈',
        rarity: ItemRarity.epic,
        achievement: 'level_10',
      ),
    };

    return trophies[type] ??
        TrophyItem(
          id: 'unknown_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Trophée inconnu',
          description: 'Un item inconnu',
          emoji: '❓',
          rarity: ItemRarity.common,
          achievement: 'unknown',
        );
  }
}
