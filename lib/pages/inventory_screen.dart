import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinopet_walker/controllers/inventory_controller.dart';
import 'package:dinopet_walker/models/inventory/inventory_item.dart';
import 'package:dinopet_walker/widgets/inventory/inventory_item_card.dart';
import 'package:dinopet_walker/widgets/inventory/inventory_pagination.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryController>().initialize();
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      context.read<InventoryController>().selectTab(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Mon Inventaire'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.restaurant_outlined),
              text: 'Nourriture',
            ),
            Tab(
              icon: Icon(Icons.checkroom_outlined),
              text: 'Accessoires',
            ),
            Tab(
              icon: Icon(Icons.emoji_events_outlined),
              text: 'Trophées',
            ),
          ],
        ),
      ),
      body: Consumer<InventoryController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4CAF50),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFoodTab(controller),
                    _buildAccessoriesTab(controller),
                    _buildTrophiesTab(controller),
                  ],
                ),
              ),
              InventoryPagination(
                controller: controller,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFoodTab(InventoryController controller) {
    final items = controller.currentTabItems
        .where((item) => item.type == ItemType.food)
        .toList();

    if (items.isEmpty) {
      return _buildEmptyState('Aucun aliment', 'Gagnez des aliments en marchant!');
    }

    return _buildItemsGrid(items);
  }

  Widget _buildAccessoriesTab(InventoryController controller) {
    final items = controller.currentTabItems
        .where((item) => item.type == ItemType.accessory)
        .toList();

    if (items.isEmpty) {
      return _buildEmptyState('Aucun accessoires', 'Équipez votre dino!');
    }

    return _buildItemsGrid(items);
  }

  Widget _buildTrophiesTab(InventoryController controller) {
    final items = controller.currentTabItems
        .where((item) => item.type == ItemType.trophy)
        .toList();

    if (items.isEmpty) {
      return _buildEmptyState('Aucun trophée', 'Atteignez des objectifs!');
    }

    return _buildItemsGrid(items);
  }

  Widget _buildItemsGrid(List<InventoryItem> items) {
    final paginatedItems = context.read<InventoryController>().paginatedItems;

    if (paginatedItems.isEmpty) {
      return _buildEmptyState('Page vide', 'Aucune autres items');
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: paginatedItems.length,
        itemBuilder: (context, index) {
          final item = paginatedItems[index];
          return InventoryItemCard(
            item: item,
            onTap: () => _showItemDialog(context, item),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDialog(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Text(
              item.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: item.getRarityColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: item.getRarityColor()),
              ),
              child: Text(
                item.getRarityLabel(),
                style: TextStyle(
                  color: item.getRarityColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          if (item.type == ItemType.accessory)
            ElevatedButton(
              onPressed: () {
                context
                    .read<InventoryController>()
                    .toggleAccessoryEquipped(item.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text('Équiper'),
            ),
        ],
      ),
    );
  }
}