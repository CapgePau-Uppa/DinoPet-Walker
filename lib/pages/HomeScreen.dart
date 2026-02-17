import 'package:dinopet_walker/controllers/HomeController.dart';
import 'package:dinopet_walker/database/dao/DailyStepsDao.dart';
import 'package:dinopet_walker/models/DinoPet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/DinoWidget.dart';
import '../widgets/UserHeader.dart';
import '../widgets/GaugeWidget.dart';

class HomeScreen extends StatefulWidget {
  final DinoPetInstance dinoPet;

  const HomeScreen({Key? key, required this.dinoPet}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dailyStepsDao = DailyStepsDao();
  late DinoPetInstance currentDino;

  @override
  void initState() {
    super.initState();
    currentDino = widget.dinoPet;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

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
            const SizedBox(height: 20),
            GaugeWidget(
              value: controller.currentSteps,
              maxValue: controller.goalSteps,
            ),
            Transform.translate(
              offset: const Offset(0, -60),
              child: DinoWidget(dinoPet: currentDino),
            ),

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
                    '${currentDino.currentStage.getName}',
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
                  Container(
                    child: Column(
                      children: [
                        ClipRRect(
                          child: LinearProgressIndicator(
                            value: currentDino.progressToNextLevel / 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        currentDino.addSteps(1000);
                      });
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('+1000'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        currentDino.addSteps(5000);
                      });
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('+5000'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        currentDino.addSteps(20000);
                      });
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('+20 000'),
                  ),

                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        currentDino.level = 1;
                        currentDino.currentSteps = 0;
                      });
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
