import 'package:dinopet_walker/controllers/inventory_controller.dart';
import 'package:flutter/material.dart';

class InventoryPagination extends StatefulWidget {
  final InventoryController controller;

  const InventoryPagination({
    super.key,
    required this.controller,
  });

  @override
  State<InventoryPagination> createState() => _InventoryPaginationState();
}

class _InventoryPaginationState extends State<InventoryPagination>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(InventoryPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = widget.controller.totalPages;
    final currentPage = widget.controller.currentPage;

    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton Précédent
            ScaleTransition(
              scale: Tween<double>(
                begin: widget.controller.canGoPrevious ? 1.0 : 0.8,
                end: 1.0,
              ).animate(_animationController),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.controller.canGoPrevious
                      ? widget.controller.previousPage
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: widget.controller.canGoPrevious
                          ? const Color(0xFF007984)
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: widget.controller.canGoPrevious
                              ? Colors.white
                              : const Color(0xFF9E9E9E),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Précédent',
                          style: TextStyle(
                            color: widget.controller.canGoPrevious
                                ? Colors.white
                                : const Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Indicateur de page
            ScaleTransition(
              scale: _animationController,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${ currentPage + 1} / $totalPages',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF007984),
                  ),
                ),
              ),
            ),
            // Bouton Suivant
            ScaleTransition(
              scale: Tween<double>(
                begin: widget.controller.canGoNext ? 1.0 : 0.8,
                end: 1.0,
              ).animate(_animationController),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.controller.canGoNext
                      ? widget.controller.nextPage
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: widget.controller.canGoNext
                          ? const Color(0xFF007984)
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Suivant',
                          style: TextStyle(
                            color: widget.controller.canGoNext
                                ? Colors.white
                                : const Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: widget.controller.canGoNext
                              ? Colors.white
                              : const Color(0xFF9E9E9E),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
