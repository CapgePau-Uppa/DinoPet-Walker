import 'package:dinopet_walker/models/inventory/food_item.dart';
import 'package:dinopet_walker/models/inventory/accessory_item.dart';
import 'package:dinopet_walker/models/inventory/trophy_item.dart';
import 'package:dinopet_walker/models/inventory/inventory_item.dart';
import 'package:dinopet_walker/services/inventory_service.dart';
import 'package:dinopet_walker/data/inventory_catalog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InventoryController extends ChangeNotifier {
  final InventoryService _inventoryService = InventoryService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Données
  List<FoodItem> _foodItems = [];
  List<AccessoryItem> _accessories = [];
  List<TrophyItem> _trophies = [];

  // État
  bool isLoading = true;
  int _currentPage = 0;
  int _selectedTabIndex = 0;

  // Constantes
  static const int itemsPerPage = 10;

  // Getters - Items débloqués seulement
  List<FoodItem> get unlockedFoodItems => _foodItems;
  List<AccessoryItem> get unlockedAccessories => _accessories;
  List<TrophyItem> get unlockedTrophies => _trophies;

  // Getters - Tous les items (débloqués + verrouillés)
  List<FoodItem> get allFoodItems {
    return InventoryCatalog.allFoodItems.map((catalogItem) {
      FoodItem? unlocked;
      try {
        unlocked = _foodItems.firstWhere((item) => item.id == catalogItem.id);
      } catch (_) {
        unlocked = null;
      }
      
      if (unlocked != null) {
        return FoodItem(
          id: catalogItem.id,
          name: catalogItem.name,
          description: catalogItem.description,
          emoji: catalogItem.emoji,
          rarity: catalogItem.rarity,
          quantity: unlocked.quantity,
          xpBonus: unlocked.xpBonus,
          acquiredAt: unlocked.acquiredAt,
          isUnlocked: true,
          unlockCondition: catalogItem.unlockCondition,
        );
      }
      return catalogItem;
    }).toList();
  }

  List<AccessoryItem> get allAccessories {
    return InventoryCatalog.allAccessoryItems.map((catalogItem) {
      AccessoryItem? unlocked;
      try {
        unlocked = _accessories.firstWhere((item) => item.id == catalogItem.id);
      } catch (_) {
        unlocked = null;
      }
      
      if (unlocked != null) {
        return AccessoryItem(
          id: catalogItem.id,
          name: catalogItem.name,
          description: catalogItem.description,
          emoji: catalogItem.emoji,
          rarity: catalogItem.rarity,
          equipped: unlocked.equipped,
          acquiredAt: unlocked.acquiredAt,
          isUnlocked: true,
          unlockCondition: catalogItem.unlockCondition,
        );
      }
      return catalogItem;
    }).toList();
  }

  List<TrophyItem> get allTrophies {
    return InventoryCatalog.allTrophyItems.map((catalogItem) {
      TrophyItem? unlocked;
      try {
        unlocked = _trophies.firstWhere((item) => item.id == catalogItem.id);
      } catch (_) {
        unlocked = null;
      }
      
      if (unlocked != null) {
        return TrophyItem(
          id: catalogItem.id,
          name: catalogItem.name,
          description: catalogItem.description,
          emoji: catalogItem.emoji,
          rarity: catalogItem.rarity,
          achievement: unlocked.achievement,
          progress: unlocked.progress,
          progressMax: unlocked.progressMax,
          acquiredAt: unlocked.acquiredAt,
          isUnlocked: true,
          unlockCondition: catalogItem.unlockCondition,
        );
      }
      return catalogItem;
    }).toList();
  }

  int get currentPage => _currentPage;
  int get selectedTabIndex => _selectedTabIndex;

  List<InventoryItem> get currentTabItems {
    switch (_selectedTabIndex) {
      case 0:
        return allFoodItems.cast<InventoryItem>();
      case 1:
        return allAccessories.cast<InventoryItem>();
      case 2:
        return allTrophies.cast<InventoryItem>();
      default:
        return [];
    }
  }

  int get totalPages {
    final count = currentTabItems.length;
    return (count / itemsPerPage).ceil().toInt();
  }

  List<InventoryItem> get paginatedItems {
    final start = _currentPage * itemsPerPage;
    final end = start + itemsPerPage;
    final items = currentTabItems;

    if (start >= items.length) return [];
    return items.sublist(start, end > items.length ? items.length : end);
  }

  bool get canGoNext => _currentPage < totalPages - 1;
  bool get canGoPrevious => _currentPage > 0;

  /// Initialiser le contrôleur
  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    final user = _auth.currentUser;
    if (user != null) {
      await loadInventory();
      
      // Si l'inventaire est vide, initialiser avec des items de base
      if (_foodItems.isEmpty && _accessories.isEmpty && _trophies.isEmpty) {
        await _initializeDefaultInventory(user.uid);
        await loadInventory();
      }

      // Vérifier et débloquer les items selon le niveau actuel
      final level = await _getDinoLevel();
      if (level != null) {
        await checkAndUnlockItems(level);
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// Récupérer le niveau actuel du dino
  Future<int?> _getDinoLevel() async {
    try {
      final dino = await _inventoryService.loadDinoLevel();
      return dino?.level;
    } catch (e) {
      debugPrint('Erreur récupération niveau: $e');
      return null;
    }
  }

  /// Initialiser l'inventaire par défaut avec des items de base
  Future<void> _initializeDefaultInventory(String uid) async {
    final defaultFood = [
      FoodItem(
        id: 'apple_starter',
        name: 'Pomme',
        description: 'Une pomme juteuse et nutritive',
        emoji: '🍎',
        rarity: ItemRarity.common,
        quantity: 3,
        xpBonus: 50,
      ),
      FoodItem(
        id: 'banana_starter',
        name: 'Banane',
        description: 'Une banane énergétique',
        emoji: '🍌',
        rarity: ItemRarity.common,
        quantity: 2,
        xpBonus: 60,
      ),
    ];

    final defaultAccessories = [
      AccessoryItem(
        id: 'hat_starter',
        name: 'Chapeau Simple',
        description: 'Un chapeau confortable',
        emoji: '🎩',
        rarity: ItemRarity.common,
        equipped: false,
      ),
    ];

    final defaultTrophies = [
      TrophyItem(
        id: 'regulier_streak',
        name: 'Régulier',
        description: 'Streak 7 jours',
        emoji: '🔥',
        rarity: ItemRarity.rare,
        achievement: 'streak_7_days',
      ),
      TrophyItem(
        id: 'marathonien',
        name: 'Marathonien',
        description: '50km marché',
        emoji: '🏃',
        rarity: ItemRarity.epic,
        achievement: 'walked_50km',
      ),
       TrophyItem(
         id: 'athlete_strava',
         name: 'Athlète Strava',
         description: '10 activités Strava',
         emoji: '⭐',
         rarity: ItemRarity.epic,
         achievement: 'strava_activities_10',
       ),
    ];

    try {
      await _inventoryService.saveInventory(
        uid,
        defaultFood,
        defaultAccessories,
        defaultTrophies,
      );
    } catch (e) {
      debugPrint('Erreur initialisation inventaire par défaut: $e');
    }
  }

  /// Charger l'inventaire depuis Firestore
  Future<void> loadInventory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final inventory = await _inventoryService.loadInventory(user.uid);

      _foodItems = (inventory['food'] ?? []) as List<FoodItem>;
      _accessories = (inventory['accessory'] ?? []) as List<AccessoryItem>;
      _trophies = (inventory['trophy'] ?? []) as List<TrophyItem>;

      // Trier par date d'acquisition (plus récent en premier)
      _foodItems.sort((a, b) => b.acquiredAt.compareTo(a.acquiredAt));
      _accessories.sort((a, b) => b.acquiredAt.compareTo(a.acquiredAt));
      _trophies.sort((a, b) => b.acquiredAt.compareTo(a.acquiredAt));

      // Réinitialiser la page
      _currentPage = 0;

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur chargement inventaire: $e');
    }
  }

  /// Changer d'onglet
  void selectTab(int index) {
    _selectedTabIndex = index;
    _currentPage = 0;
    notifyListeners();
  }

  /// Aller à la page suivante
  void nextPage() {
    if (canGoNext) {
      _currentPage++;
      notifyListeners();
    }
  }

  /// Aller à la page précédente
  void previousPage() {
    if (canGoPrevious) {
      _currentPage--;
      notifyListeners();
    }
  }

  /// Ajouter un item de nourriture
  Future<void> addFoodItem(FoodItem item) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _inventoryService.addFoodItem(user.uid, item);
    await loadInventory();
  }

  /// Ajouter un accessoire
  Future<void> addAccessoryItem(AccessoryItem item) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _inventoryService.addAccessoryItem(user.uid, item);
    await loadInventory();
  }

  /// Ajouter un trophée
  Future<void> addTrophyItem(TrophyItem item) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _inventoryService.addTrophyItem(user.uid, item);
    await loadInventory();
  }

  /// Vérifier et débloquer les items selon le niveau actuel
  Future<void> checkAndUnlockItems(int currentLevel) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Items à débloquer selon le niveau
    final itemsToUnlock = <Map<String, dynamic>>[];

    if (currentLevel >= 5) {
      itemsToUnlock.add({
        'id': 'acc_chapeau',
        'name': 'Chapeau',
        'emoji': '🎩',
        'description': 'Un chapeau élégant',
        'rarity': ItemRarity.common,
      });
    }

    if (currentLevel >= 10) {
      itemsToUnlock.add({
        'id': 'acc_lunettes',
        'name': 'Lunettes',
        'emoji': '👓',
        'description': 'Des lunettes stylées',
        'rarity': ItemRarity.rare,
      });
    }

    if (currentLevel >= 25) {
      itemsToUnlock.add({
        'id': 'acc_costume',
        'name': 'Costume Spécial',
        'emoji': '🦖',
        'description': 'Un costume épique',
        'rarity': ItemRarity.epic,
      });
    }

    // Ajouter les items s'ils ne sont pas déjà présents
    for (final itemData in itemsToUnlock) {
      final exists = _accessories.any((a) => a.id == itemData['id']);
      if (!exists) {
        final newItem = AccessoryItem(
          id: itemData['id'],
          name: itemData['name'],
          description: itemData['description'],
          emoji: itemData['emoji'],
          rarity: itemData['rarity'],
          equipped: false,
          acquiredAt: DateTime.now(),
        );
        await addAccessoryItem(newItem);
      }
    }
  }

  /// Équiper/Dés-équiper un accessoire
  Future<void> toggleAccessoryEquipped(String accessoryId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _inventoryService.toggleAccessoryEquipped(user.uid, accessoryId);
    await loadInventory();
  }
}
