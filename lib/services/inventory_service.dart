import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinopet_walker/models/inventory/food_item.dart';
import 'package:dinopet_walker/models/inventory/accessory_item.dart';
import 'package:dinopet_walker/models/inventory/trophy_item.dart';
import 'package:dinopet_walker/models/inventory/inventory_item.dart';
import 'package:flutter/material.dart';

class InventoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Charger l'inventaire complet pour un utilisateur
  Future<Map<String, List<InventoryItem>>> loadInventory(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).collection('inventory').doc('items').get();

      if (!doc.exists) {
        return {
          'food': [],
          'accessory': [],
          'trophy': [],
        };
      }

      final data = doc.data() ?? {};

      final foodItems = (data['foodItems'] as List? ?? [])
          .map((item) => FoodItem.fromFirestore(item['id'], item))
          .toList();

      final accessories = (data['accessories'] as List? ?? [])
          .map((item) => AccessoryItem.fromFirestore(item['id'], item))
          .toList();

      final trophies = (data['trophies'] as List? ?? [])
          .map((item) => TrophyItem.fromFirestore(item['id'], item))
          .toList();

      return {
        'food': foodItems,
        'accessory': accessories,
        'trophy': trophies,
      };
    } catch (e) {
      debugPrint('Erreur chargement inventaire: $e');
      return {
        'food': [],
        'accessory': [],
        'trophy': [],
      };
    }
  }

  /// Sauvegarder l'inventaire complet
  Future<void> saveInventory(
    String uid,
    List<FoodItem> foodItems,
    List<AccessoryItem> accessories,
    List<TrophyItem> trophies,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('inventory')
          .doc('items')
          .set({
        'foodItems': foodItems.map((item) => {'id': item.id, ...item.toFirestore()}).toList(),
        'accessories': accessories.map((item) => {'id': item.id, ...item.toFirestore()}).toList(),
        'trophies': trophies.map((item) => {'id': item.id, ...item.toFirestore()}).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erreur sauvegarde inventaire: $e');
    }
  }

  /// Ajouter un item de nourriture
  Future<void> addFoodItem(String uid, FoodItem item) async {
    try {
      final inventory = await loadInventory(uid);
      final foodList = inventory['food'] as List<FoodItem>;

      // Vérifier si l'item existe déjà
      final existingIndex = foodList.indexWhere((f) => f.id == item.id);
      if (existingIndex != -1) {
        // Augmenter la quantité
        foodList[existingIndex] = FoodItem(
          id: foodList[existingIndex].id,
          name: foodList[existingIndex].name,
          description: foodList[existingIndex].description,
          emoji: foodList[existingIndex].emoji,
          rarity: foodList[existingIndex].rarity,
          quantity: foodList[existingIndex].quantity + item.quantity,
          xpBonus: foodList[existingIndex].xpBonus,
          acquiredAt: foodList[existingIndex].acquiredAt,
        );
      } else {
        foodList.add(item);
      }

      await saveInventory(uid, foodList, inventory['accessory'] as List<AccessoryItem>, inventory['trophy'] as List<TrophyItem>);
    } catch (e) {
      debugPrint('Erreur ajout nourriture: $e');
    }
  }

  /// Ajouter un accessoire
  Future<void> addAccessoryItem(String uid, AccessoryItem item) async {
    try {
      final inventory = await loadInventory(uid);
      final accessories = inventory['accessory'] as List<AccessoryItem>;

      // Vérifier si l'item existe déjà
      if (!accessories.any((a) => a.id == item.id)) {
        accessories.add(item);
        await saveInventory(uid, inventory['food'] as List<FoodItem>, accessories, inventory['trophy'] as List<TrophyItem>);
      }
    } catch (e) {
      debugPrint('Erreur ajout accessoire: $e');
    }
  }

  /// Ajouter un trophée
  Future<void> addTrophyItem(String uid, TrophyItem item) async {
    try {
      final inventory = await loadInventory(uid);
      final trophies = inventory['trophy'] as List<TrophyItem>;

      if (!trophies.any((t) => t.id == item.id)) {
        trophies.add(item);
        await saveInventory(uid, inventory['food'] as List<FoodItem>, inventory['accessory'] as List<AccessoryItem>, trophies);
      }
    } catch (e) {
      debugPrint('Erreur ajout trophée: $e');
    }
  }

  /// Équiper/Dés-équiper un accessoire
  Future<void> toggleAccessoryEquipped(String uid, String accessoryId) async {
    try {
      final inventory = await loadInventory(uid);
      final accessories = inventory['accessory'] as List<AccessoryItem>;

      for (int i = 0; i < accessories.length; i++) {
        if (accessories[i].id == accessoryId) {
          accessories[i] = AccessoryItem(
            id: accessories[i].id,
            name: accessories[i].name,
            description: accessories[i].description,
            emoji: accessories[i].emoji,
            rarity: accessories[i].rarity,
            equipped: !accessories[i].equipped,
            acquiredAt: accessories[i].acquiredAt,
          );
          break;
        }
      }

      await saveInventory(uid, inventory['food'] as List<FoodItem>, accessories, inventory['trophy'] as List<TrophyItem>);
    } catch (e) {
      debugPrint('Erreur équipement accessoire: $e');
    }
  }
}
