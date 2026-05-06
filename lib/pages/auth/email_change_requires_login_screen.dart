import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:dinopet_walker/widgets/common/step_widget.dart';
import 'package:dinopet_walker/pages/auth/auth_wrapper.dart';
import 'package:flutter/material.dart';

class EmailChangeRequiresLoginScreen extends StatelessWidget {
  const EmailChangeRequiresLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 255, 222),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logos/logo.png", height: 110),

              const SizedBox(height: 32),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3A2D).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_person_outlined,
                  size: 38,
                  color: Color(0xFF1B3A2D),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Lien expiré",
                style: TextStyle(
                  color: Color(0xFF1B3A2D),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Vous vous êtes déconnecté !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1B3A2D).withValues(alpha: 0.45),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3A2D).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 25,
                          color: const Color(0xFF1B3A2D).withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Pour valider le changement :",
                          style: TextStyle(
                            color: const Color(
                              0xFF1B3A2D,
                            ).withValues(alpha: 0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    StepWidget(
                      number: "1",
                      text: "Connectez vous avec votre adresse email actuelle.",
                    ),
                    const SizedBox(height: 8),
                    StepWidget(
                      number: "2",
                      text: "Accédez a Paramètres › Modifier mon profil.",
                    ),
                    const SizedBox(height: 8),
                    StepWidget(
                      number: "3",
                      text: "Insérez votre nouveau email.",
                    ),
                    const SizedBox(height: 8),
                    StepWidget(number: "4", text: "Confirmez votre mot de passe."),
                    const SizedBox(height: 8),
                    StepWidget(number: "5", text: "Restez connecté a votre compte lors de la validation du lien."),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              PrimaryButton(
                label: 'Se connecter',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthWrapper()),
                    (route) => false,
                  );
                },
                width: width * 0.6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

