import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import '../widgets/home/permession/permission_tile.dart';
import '../widgets/common/primary_button.dart';
import '../services/permission_service.dart';

class MapPermissionScreen extends StatelessWidget {
  final bool isPermanentlyDenied;
  final VoidCallback onRetry;

  const MapPermissionScreen({
    super.key,
    required this.isPermanentlyDenied,
    required this.onRetry,
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

                _buildIllustration(),

                const SizedBox(height: 40),

                const Text(
                  "Où êtes-vous ?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),

                const SizedBox(height: 12),

                // SECTION MISE À JOUR : Style rédactionnel identique à Home
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
                            " puisse suivre vos aventures, il a besoin de connaître votre ",
                      ),
                      TextSpan(
                        text: "position géographique",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      TextSpan(
                        text:
                            ".\n\nActivez la localisation pour tracer votre parcours sur la carte.",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                PermissionTile(
                  icon: Icons.location_on_rounded,
                  title: "Localisation GPS",
                  subtitle: "Nécessaire pour le suivi",
                  isOk: false,
                  color: const Color(0xFF2E7D32),
                ),

                const Spacer(),

                PrimaryButton(
                  label: isPermanentlyDenied ? 'Paramètres' : 'Autoriser',
                  onPressed: isPermanentlyDenied
                      ? () => AppSettings.openAppSettings()
                      : () async {
                    await PermissionService().requestMapPermissions();

                    final statuses = await PermissionService().checkMapPermissions();

                    if (statuses['location'] == true) {
                      onRetry();
                    }
                  },
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

  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
        ),
        const Icon(
          Icons.location_off_rounded,
          size: 70,
          color: Color(0xFF2E7D32),
        ),
      ],
    );
  }
}