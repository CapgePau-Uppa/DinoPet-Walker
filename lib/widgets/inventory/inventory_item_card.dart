import 'package:dinopet_walker/models/inventory/inventory_item.dart';
import 'package:flutter/material.dart';

class InventoryItemCard extends StatefulWidget {
  final InventoryItem item;
  final VoidCallback? onTap;

  const InventoryItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  State<InventoryItemCard> createState() => _InventoryItemCardState();
}

class _InventoryItemCardState extends State<InventoryItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: widget.item.isUnlocked
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF536976),
                      Color(0xFFBBD2C5),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey[400]!,
                      Colors.grey[300]!,
                    ],
                  ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCED6E0).withValues(
                  alpha: _isHovered ? 0.8 : 0.4,
                ),
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Opacity(
                              opacity: widget.item.isUnlocked ? 1.0 : 0.5,
                              child: Text(
                                widget.item.emoji,
                                style: const TextStyle(
                                  fontSize: 48,
                                ),
                              ),
                            ),
                            if (!widget.item.isUnlocked)
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
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                          ],
                        ),
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
                            widget.item.getRarityLabel(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        widget.item.isUnlocked 
                          ? widget.item.description 
                          : 'Verrouillé: ${widget.item.unlockCondition}',
                        style: TextStyle(
                          fontSize: 11,
                          color: widget.item.isUnlocked ? const Color(0xFF666666) : const Color(0xFF999999),
                          height: 1.3,
                          fontStyle: widget.item.isUnlocked ? FontStyle.normal : FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
