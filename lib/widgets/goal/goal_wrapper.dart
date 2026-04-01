import 'package:dinopet_walker/controllers/firestore/user_controller.dart';
import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/pages/goal_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().getOrCreateUserOnFirestore();

      context.read<HomeController>().loadGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();

    if (homeController.isLoadingGoal) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF1B4965))),
      );
    }

    if (!homeController.isGoalSet) {
      return const GoalScreen(goalType: GoalType.steps);
    }

    return const SelectionScreen();
  }
}