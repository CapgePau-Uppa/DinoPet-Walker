// lib/pages/HomeScreen.dart
import 'package:dinopet_walker/controllers/HomeController.dart';
import 'package:dinopet_walker/database/dao/DailyStepsDao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/DinoWidget.dart';
import '../widgets/UserHeader.dart';
import '../widgets/GaugeWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dailyStepsDao = DailyStepsDao();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>(); // écouter le controller

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserHeader(
              username: "Michel",
              userLevel: controller.userLevel,
              streak: 5,
            ),
            const SizedBox(height: 20),
            GaugeWidget(
              value: controller.currentSteps,
              maxValue: controller.goalSteps,
            ),
            Transform.translate(
              offset: const Offset(0, -60),
              child: DinoWidget(userLevel: controller.userLevel),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.decreaseLevel,
                  child: const Text("-5"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: controller.increaseLevel,
                  child: const Text("+5"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
