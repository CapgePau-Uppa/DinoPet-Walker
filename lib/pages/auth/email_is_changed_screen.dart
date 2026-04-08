import 'package:dinopet_walker/controllers/user/user_controller.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:dinopet_walker/pages/auth/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailChangedScreen extends StatelessWidget {
  const EmailChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final isUserLoggedIn = context.read<UserController>().isLoggedIn;

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
                  Icons.mark_email_read_outlined,
                  size: 38,
                  color: Color(0xFF1B3A2D),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Votre adresse email \na bien été modifiée.",
                style: TextStyle(
                  color: Color(0xFF1B3A2D),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  height: 1.1,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 25,
                      color: const Color(0xFF1B3A2D).withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Utilisez votre nouvelle adresse email pour vous connecter lors de votre prochaine connexion.",
                        style: TextStyle(
                          color: const Color(0xFF1B3A2D).withValues(alpha: 0.6),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              PrimaryButton(
                label: isUserLoggedIn ? 'Continuer' : 'Se connecter',
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
