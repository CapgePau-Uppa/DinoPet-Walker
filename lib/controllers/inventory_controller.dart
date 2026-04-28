import 'package:dinopet_walker/models/inventory/food_item.dart';
import 'package:dinopet_walker/models/inventory/accessory_item.dart';
import 'package:dinopet_walker/models/inventory/trophy_item.dart';
import 'package:dinopet_walker/models/inventory/inventory_item.dart';
import 'package:dinopet_walker/services/inventory_service.dart';
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

  // Getters
  List<FoodItem> get foodItems => _foodItems;
  List<AccessoryItem> get accessories => _accessories;
  List<TrophyItem> get trophies => _trophies;

  int get currentPage => _currentPage;
  int get selectedTabIndex => _selectedTabIndex;

  List<InventoryItem> get currentTabItems {
    switch (_selectedTabIndex) {
      case 0:
        return _foodItems;
      case 1:
        return _accessories;
      case 2:
        return _trophies;
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
    }

    isLoading = false;
    notifyListeners();
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
        id: 'first_steps_starter',
        name: 'Premiers Pas',
        description: 'Atteindre 1000 pas',
        emoji: '👣',
        rarity: ItemRarity.common,
        achievement: 'first_steps',
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

  /// Équiper/Dés-équiper un accessoire
  Future<void> toggleAccessoryEquipped(String accessoryId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _inventoryService.toggleAccessoryEquipped(user.uid, accessoryId);
    await loadInventory();
  }
}
