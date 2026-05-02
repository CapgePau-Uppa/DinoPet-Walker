import 'package:dinopet_walker/models/dino/dino_nature.dart';
import 'package:flutter/material.dart';

class DinoDetailsWidget extends StatelessWidget {
  final Nature nature;
  final String typeName;
  final String currentStage;

  const DinoDetailsWidget({
    super.key,
    required this.nature,
    required this.typeName,
    required this.currentStage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      typeName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Compagnon",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 35,
                width: 1.5,
                color: Colors.black.withValues(alpha: 0.2),
              ),

              Expanded(
                child: Column(
                  children: [
                    Text(
                      nature.label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Espèce",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 35,
                width: 1.5,
                color: Colors.black.withValues(alpha: 0.2),
              ),

              Expanded(
                child: Column(
                  children: [
                    Text(
                      currentStage,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Stade",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
