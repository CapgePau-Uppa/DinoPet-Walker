import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/common/my_appbar.dart';
import '../widgets/common/toast.dart';

enum GoalType { steps, time, distance }

class GoalTier {
  final String title;
  final int target;
  final Color color;
  final IconData icon;

  GoalTier(this.title, this.target, this.color, this.icon);
}

class GoalScreen extends StatefulWidget {
  final GoalType goalType;

  const GoalScreen({super.key, required this.goalType});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  late int _selectedTarget;
  late TextEditingController _customTargetController;

  String get screenTitle {
    switch (widget.goalType) {
      case GoalType.steps: return "Objectif de pas";
      case GoalType.time: return "Temps d'activité";
      case GoalType.distance: return "Objectif de distance";
    }
  }

  String get unit {
    switch (widget.goalType) {
      case GoalType.steps: return "pas / jour";
      case GoalType.time: return "min / jour";
      case GoalType.distance: return "km / jour";
    }
  }

  List<GoalTier> get currentTiers {
    switch (widget.goalType) {
      case GoalType.steps:
        return [
          GoalTier("Débutant", 4000, const Color(0xFFD38B86), Icons.military_tech),
          GoalTier("Intermédiaire", 7000, const Color(0xFF8B3A36), Icons.workspace_premium),
          GoalTier("Actif", 10000, const Color(0xFFE83E8C), Icons.military_tech),
          GoalTier("Sportif", 12000, const Color(0xFF6f42c1), Icons.emoji_events),
          GoalTier("Champion", 15000, const Color(0xFFB8A236), Icons.emoji_events),
        ];
      case GoalType.time:
        return [
          GoalTier("Débutant", 15, const Color(0xFFD38B86), Icons.timer),
          GoalTier("Intermédiaire", 30, const Color(0xFF8B3A36), Icons.timer),
          GoalTier("Actif", 45, const Color(0xFFE83E8C), Icons.timer),
          GoalTier("Sportif", 60, const Color(0xFF6f42c1), Icons.timer),
          GoalTier("Champion", 90, const Color(0xFFB8A236), Icons.timer),
        ];
      case GoalType.distance:
        return [
          GoalTier("Débutant", 2, const Color(0xFFD38B86), Icons.directions_run),
          GoalTier("Intermédiaire", 4, const Color(0xFF8B3A36), Icons.directions_run),
          GoalTier("Actif", 6, const Color(0xFFE83E8C), Icons.directions_run),
          GoalTier("Sportif", 10, const Color(0xFF6f42c1), Icons.directions_run),
          GoalTier("Champion", 15, const Color(0xFFB8A236), Icons.directions_run),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    final homeController = context.read<HomeController>();

    switch (widget.goalType) {
      case GoalType.steps:
        _selectedTarget = homeController.goalSteps;
        break;
      case GoalType.time:
        _selectedTarget = homeController.goalTime;
        break;
      case GoalType.distance:
        _selectedTarget = homeController.goalDistance;
        break;
    }

    _customTargetController = TextEditingController(text: _selectedTarget.toString());
  }

  @override
  void dispose() {
    _customTargetController.dispose();
    super.dispose();
  }

  void _selectTier(int target) {
    setState(() {
      _selectedTarget = target;
      _customTargetController.text = target.toString();
    });
  }

  void _saveAndContinue() {
    final int finalGoal = int.tryParse(_customTargetController.text) ?? 0;
    final homeController = context.read<HomeController>();

    switch (widget.goalType) {
      case GoalType.steps:
        homeController.updateGoalSteps(finalGoal);
        break;
      case GoalType.time:
        homeController.updateGoalTime(finalGoal);
        break;
      case GoalType.distance:
        homeController.updateGoalDistance(finalGoal);
        break;
    }

    Toast.show(
      context: context,
      message: "Objectif défini avec succès !",
      icon: Icons.check_circle_outline,
      color: const Color(0xFF4CAF50),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tiers = currentTiers;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: Myappbar(title: screenTitle, showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Sélectionner un objectif",
                    style: TextStyle(color: Color(0xFF1B4965), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: tiers.length,
                    itemBuilder: (context, index) {
                      final tier = tiers[index];
                      final isSelected = _selectedTarget == tier.target;

                      return GestureDetector(
                        onTap: () => _selectTier(tier.target),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: tier.color,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelected
                                ? [BoxShadow(color: tier.color.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 2)]
                                : [],
                            border: isSelected
                                ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(tier.icon, color: Colors.white, size: 30),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tier.title,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    "${tier.target} $unit",
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _customTargetController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF65A0A6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                decoration: const InputDecoration(border: InputBorder.none),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedTarget = int.tryParse(val) ?? 0;
                                  });
                                },
                              ),
                            ),
                            const Icon(Icons.edit, color: Color(0xFF1B4965), size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: "Définir l'objectif",
                          onPressed: _saveAndContinue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}