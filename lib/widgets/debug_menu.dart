import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/dino_controller.dart';

class DebugMenu extends StatelessWidget {
  const DebugMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = context.read<HomeController>();
    final dinoController = context.read<DinoController>();

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => homeController.addSteps(1000),
                icon: const Icon(Icons.add),
                label: const Text("+1000"),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () => homeController.addSteps(5000),
                icon: const Icon(Icons.add),
                label: const Text("+5000"),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () => homeController.addSteps(20000),
                icon: const Icon(Icons.add),
                label: const Text("+20000"),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () => dinoController.resetDino(),
                icon: const Icon(Icons.refresh),
                label: const Text("Reset Dino"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
