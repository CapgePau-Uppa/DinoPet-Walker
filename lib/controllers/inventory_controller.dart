import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';

class InventoryController extends ChangeNotifier {
  final InventoryService _inventoryService = InventoryService();

  List<InventoryItem> _currentPageItems = [];
  int _currentPage = 1;
  bool _isLoading = false;

  final Map<int, DocumentSnapshot?> _pageTokens = {1: null};
  final int _perPage = 10;

  List<InventoryItem> get items => _currentPageItems;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> goToPage(int page) async {
    if (_userId == null || _isLoading) return;
    if (page < 1 || (page > 1 && !_pageTokens.containsKey(page))) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _inventoryService.getInventoryPage(
        _userId!,
        _perPage,
        startAt: page > 1 ? _pageTokens[page] : null,
      );

      _currentPageItems = snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc)).toList();
      _currentPage = page;

      if (snapshot.docs.length == _perPage) {
        _pageTokens[page + 1] = snapshot.docs.last;
      }
    } catch (e) {
      debugPrint("Erreur pagination : $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  bool hasNextPage() => _pageTokens.containsKey(_currentPage + 1);
  bool hasPreviousPage() => _currentPage > 1;
}