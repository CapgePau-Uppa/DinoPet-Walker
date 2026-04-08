import 'package:dinopet_walker/controllers/dino/dino_controller.dart';
import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/pages/goal_screen.dart';
import 'package:dinopet_walker/pages/main_screen.dart';
import 'package:dinopet_walker/pages/selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalWrapper extends StatefulWidget {
  const GoalWrapper({super.key});

  @override
  State<GoalWrapper> createState() => _GoalWrapperState();
}

class _GoalWrapperState extends State<GoalWrapper> {

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await context.read<HomeController>().loadGoal();
    if (mounted) await context.read<DinoController>().loadDinoPet();
  });
}

@override
Widget build(BuildContext context) {
  final homeController = context.watch<HomeController>();
  final dinoController = context.watch<DinoController>();

  if (homeController.isLoadingGoal || dinoController.isLoading) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF1B4965)),
      ),
    );
  }

  if (!homeController.isGoalSet) {
    return const GoalScreen(goalType: GoalType.steps, showBackButton: false);
  }

  if (dinoController.dinoPet != null) {
    return const MainScreen();
  }

  return const SelectionScreen();
}
}