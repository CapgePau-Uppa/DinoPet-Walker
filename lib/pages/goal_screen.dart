import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalTier {
  final String title;
  final int steps;
  final Color color;
  final IconData icon;

  GoalTier(this.title, this.steps, this.color, this.icon);
}

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final List<GoalTier> tiers = [
    GoalTier("Débutant", 4000, const Color(0xFFD38B86), Icons.military_tech),
    GoalTier("Intermédiaire", 7000, const Color(0xFF8B3A36), Icons.workspace_premium),
    GoalTier("Actif", 10000, const Color(0xFFE83E8C), Icons.military_tech),
    GoalTier("Sportif", 12000, const Color(0xFF6f42c1), Icons.emoji_events),
    GoalTier("Champion", 15000, const Color(0xFFB8A236), Icons.emoji_events),
  ];

  late int _selectedSteps;
  late TextEditingController _customStepsController;

  @override
  void initState() {
    super.initState();
    _selectedSteps = context.read<HomeController>().goalSteps;
    _customStepsController = TextEditingController(text: _selectedSteps.toString());
  }

  @override
  void dispose() {
    _customStepsController.dispose();
    super.dispose();
  }

  void _selectTier(int steps) {
    setState(() {
      _selectedSteps = steps;
      _customStepsController.text = steps.toString();
    });
  }

  void _saveAndContinue() {
    final int finalGoal = int.tryParse(_customStepsController.text) ?? 10000;
    context.read<HomeController>().updateGoalSteps(finalGoal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Mon objectif",
          style: TextStyle(color: Color(0xFF1B4965), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
                      final isSelected = _selectedSteps == tier.steps;

                      return GestureDetector(
                        onTap: () => _selectTier(tier.steps),
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
                                    "${tier.steps} pas / jour",
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
                                controller: _customStepsController,
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
                                    _selectedSteps = int.tryParse(val) ?? 10000;
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