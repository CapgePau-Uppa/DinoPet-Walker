import 'package:dinopet_walker/controllers/DinoController.dart';
import 'package:dinopet_walker/controllers/HomeController.dart';
import 'package:dinopet_walker/widgets/dino/AnimatedDinoWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/home/UserHeader.dart';
import '../widgets/home/GaugeWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();
    final dinoController = context.watch<DinoController>();
    final currentDino = dinoController.dinoPet!;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserHeader(
              username: "Michel",
              userLevel: currentDino.level,
              streak: 1,
            ),
            const SizedBox(height: 15),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                GaugeWidget(
                  value: homeController.currentSteps,
                  maxValue: homeController.goalSteps,
                ),
                Positioned(
                  top: 280 - 150,
                  child: AnimatedDinoWidget(
                    dinoPet: currentDino,
                    onStageEvolved: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 220),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    currentDino.type.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: currentDino.type.innerColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentDino.currentStage.getName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${currentDino.getTotalStepsCollected()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipRRect(
                    child: LinearProgressIndicator(
                      value: currentDino.progressToNextLevel / 100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => homeController.addSteps(1000),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('+1000'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => homeController.addSteps(5000),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('+5000'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => homeController.addSteps(20000),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('+20 000'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      currentDino.level = 1;
                      currentDino.xpSteps = 0;
                      dinoController.notifyListeners();
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
