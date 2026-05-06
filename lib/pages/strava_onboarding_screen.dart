import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/activity/activity_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/home_controller.dart';

class StravaOnboardingScreen extends StatefulWidget {
  const StravaOnboardingScreen({super.key});

  @override
  State<StravaOnboardingScreen> createState() => _StravaOnboardingScreenState();
}

class _StravaOnboardingScreenState extends State<StravaOnboardingScreen> {
  bool _isLoading = false;
  final SettingsController _controller = SettingsController();

  Future<void> _connectStrava() async {
    setState(() => _isLoading = true);
    final success = await _controller.linkStrava();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Toast.show(
        context: context,
        message: "Compte Strava lié avec succès !",
        icon: Icons.check_circle,
        color: const Color(0xFF4CAF50),
      );

      await context.read<ActivityController>().loadActivities();
      if (mounted) context.read<HomeController>().completeStravaOnboarding();

    } else {
      Toast.show(
        context: context,
        message: "Erreur lors de la connexion à Strava",
        icon: Icons.highlight_off,
        color: const Color(0xFFC94A4A),
      );
    }
  }

  void _skipStrava() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Pas de problème !",
          style: TextStyle(color: Color(0xFF1B4965), fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Vous pourrez toujours lier votre compte Strava plus tard en vous rendant dans les Paramètres de l'application.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF65A0A6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<HomeController>().completeStravaOnboarding();
            },
            child: const Text("J'ai compris", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: const Icon(Icons.directions_run, size: 80, color: Color(0xFFFC4C02)),
              ),

              const SizedBox(height: 40),
              const Text(
                "Passez au niveau supérieur !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B4965)),
              ),
              const SizedBox(height: 16),
              const Text(
                "Liez votre compte Strava pour suivre vos temps d'activité et vos distances parcourues directement dans DinoPet. Débloquez de nouveaux objectifs !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _connectStrava,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC4C02),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.link, color: Colors.white),
                  label: const Text(
                    "Connecter mon compte Strava",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: _isLoading ? null : _skipStrava,
                child: const Text(
                  "Plus tard",
                  style: TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}