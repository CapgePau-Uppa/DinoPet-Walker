import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:dinopet_walker/widgets/login/auth_wrapper.dart';
import 'package:flutter/material.dart';

class EmailIsVerifiedScreen extends StatelessWidget {
  const EmailIsVerifiedScreen({super.key});

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

              const SizedBox(height: 24),

              const Text(
                "Email vérifié !",
                style: TextStyle(
                  color: Color(0xFF1B3A2D),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Ton compte est maintenant activé,\nbienvenue sur DinoPet !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1B3A2D).withValues(alpha: 0.45),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: PrimaryButton(
                  label: 'Continuer',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthWrapper()),
                      (route) => false,
                    );
                  },
                  width: width * 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
