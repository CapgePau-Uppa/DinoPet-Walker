import 'package:dinopet_walker/controllers/email_verification_controller.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/widgets/login/auth_wrapper.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final EmailVerificationController _controller = EmailVerificationController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.sendEmailVerification();
    });
  }

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
                "Vérifie ton email",
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
                "Un lien de vérification a été envoyé\nà ton adresse email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1B3A2D).withValues(alpha: 0.45),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 28),

                Center(
                  child: PrimaryButton(
                    label: 'Retour', 
                    onPressed: () async {
                      await _controller.signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthWrapper()),
                        (route) => false,
                      );
                    },
                    width: width*0.5,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
