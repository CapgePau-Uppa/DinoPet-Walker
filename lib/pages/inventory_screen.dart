import 'package:dinopet_walker/widgets/common/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/inventory_controller.dart';
import '../models/inventory_item.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryController>().goToPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InventoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: Myappbar(title: "Mon inventaire"),
      body: Column(
        children: [
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.items.isEmpty
                ? _buildEmpty()
                : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.items.length,
              itemBuilder: (context, index) => _buildItemCard(controller.items[index]),
            ),
          ),
          _buildPager(controller),
        ],
      ),
    );
  }

  Widget _buildItemCard(InventoryItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFC4C02).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.iconName == 'apple' ? Icons.apple : Icons.help_outline,
              color: const Color(0xFFFC4C02),
              size: 38,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPager(InventoryController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PagerButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: controller.hasPreviousPage() ? () => controller.goToPage(controller.currentPage - 1) : null,
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFC4C02).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              "Page ${controller.currentPage}",
              style: const TextStyle(color: Color(0xFFFC4C02), fontWeight: FontWeight.bold),
            ),
          ),

          _PagerButton(
            icon: Icons.arrow_forward_ios,
            onPressed: controller.hasNextPage() ? () => controller.goToPage(controller.currentPage + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text("Votre sac est vide", style: TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }
}

class _PagerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const _PagerButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: onPressed == null ? Colors.grey.shade300 : const Color(0xFF1B4965)),
    );
  }
}