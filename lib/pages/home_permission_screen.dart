import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

import '../widgets/home/permession/permission_tile.dart';
import '../widgets/home/permession/permission_illustration.dart';
import '../widgets/common/primary_button.dart';

class HomePermissionScreen extends StatelessWidget {
  final bool activityOk;
  final bool healthOk;

  const HomePermissionScreen({
    super.key,
    required this.activityOk,
    required this.healthOk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF1F5F9)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Spacer(),

                const PermissionIllustration(),

                const SizedBox(height: 40),

                const Text(
                  "On y est presque !",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),

                const SizedBox(height: 12),

                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: "Pour que "),
                      TextSpan(
                        text: "DinoPet",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: Color(0xFF2E7D32),
                          letterSpacing: 0.5,
                        ),
                      ),
                      TextSpan(
                        text:
                            " puisse évoluer avec vous, il a besoin d'accéder à vos ",
                      ),
                      TextSpan(
                        text: "données d’activité",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      TextSpan(text: " et de "),
                      TextSpan(
                        text: "santé",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      TextSpan(
                        text:
                            ".\n\nActivez-les dans les paramètres pour continuer",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                PermissionTile(
                  icon: Icons.directions_run_rounded,
                  title: "Activité Physique",
                  subtitle: "Pour compter vos pas",
                  isOk: activityOk,
                  color: const Color(0xFF2E7D32),
                ),

                const SizedBox(height: 16),

                PermissionTile(
                  icon: Icons.favorite_rounded,
                  title: "Données de Santé",
                  subtitle: "Pour synchroniser l'effort",
                  isOk: healthOk,
                  color: const Color(0xFF2E7D32),
                ),

                const Spacer(),

                PrimaryButton(
                  label: 'Paramètres',
                  onPressed: () => AppSettings.openAppSettings(),
                  width: double.infinity,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
