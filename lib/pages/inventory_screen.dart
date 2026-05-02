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
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<InventoryController>().selectTab(_tabController.index);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryController>().initialize();
    });
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
        toolbarHeight: 75,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Center(
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFEDFFEA),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 24,
                color: Color(0xFF007984),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Mon Inventaire',
          style: TextStyle(
            color: Color(0xFF007984),
            fontWeight: FontWeight.w900,
            fontSize: 25,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withValues(alpha: 0.1),
            height: 4.0,
          ),
        ),
      ),
      body: Consumer<InventoryController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF007984),
              ),
            );
          }

          return Column(
            children: [
              _buildTabBar(),
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCED6E0).withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF007984),
          borderRadius: BorderRadius.circular(16),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        unselectedLabelColor: const Color(0xFF999999),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(6),
        tabs: const [
          Tab(text: '🍖 Nourriture'),
          Tab(text: '🎁 Accessoires'),
          Tab(text: '🏆 Trophées'),
        ],
      ),
    );
  }

  Widget _buildFoodTab(InventoryController controller) {
    final items = controller.allFoodItems;
    if (items.isEmpty) {
      return _buildEmptyState('Aucun aliment', 'Gagnez des aliments en marchant!');
    }
    return _buildItemsGrid(items.cast<InventoryItem>());
  }

  Widget _buildAccessoriesTab(InventoryController controller) {
    final items = controller.allAccessories;
    if (items.isEmpty) {
      return _buildEmptyState('Aucun accessoire', 'Équipez votre dino!');
    }
    return _buildItemsGrid(items.cast<InventoryItem>());
  }

  Widget _buildTrophiesTab(InventoryController controller) {
    final items = controller.allTrophies;
    if (items.isEmpty) {
      return _buildEmptyState('Aucun trophée', 'Atteignez des objectifs!');
    }
    return _buildItemsGrid(items.cast<InventoryItem>());
  }

  Widget _buildItemsGrid(List<InventoryItem> items) {
    final paginatedItems = context.read<InventoryController>().paginatedItems;

    if (paginatedItems.isEmpty) {
      return _buildEmptyState('Page vide', 'Aucune autres items');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
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
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Opacity(
                        opacity: item.isUnlocked ? 1.0 : 0.5,
                        child: Text(
                          item.emoji,
                          style: const TextStyle(
                            fontSize: 48,
                          ),
                        ),
                      ),
                      if (!item.isUnlocked)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '🔒',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECE9E6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.getRarityLabel(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2C2C2C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (item.isUnlocked)
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    border: Border.all(color: Colors.orange[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock, color: Colors.orange[600], size: 20),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Item verrouillé',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFCC6600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pour débloquer: ${item.unlockCondition}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF996600),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF757575),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Fermer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (item.type == ItemType.accessory && item.isUnlocked)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<InventoryController>()
                              .toggleAccessoryEquipped(item.id);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007984),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Équiper'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}