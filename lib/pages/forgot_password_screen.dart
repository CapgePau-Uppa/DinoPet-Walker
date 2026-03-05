import 'package:dinopet_walker/controllers/forgot_password_controller.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:dinopet_walker/widgets/login/email_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController _controller = ForgotPasswordController();
  final TextEditingController emailController = TextEditingController();
  bool _loading = false;

  Future<void> _sendResetEmail() async {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    final error = await _controller.sendResetPasswordEmail(
      email: emailController.text.trim(),
    );

    if (mounted) setState(() => _loading = false);

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email de réinitialisation envoyé')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 217, 255, 222),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Image.asset("assets/logos/logo.png", height: 130),

                  const SizedBox(height: 16),

                  const Text(
                    "Mot de passe\noublié ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1B3A2D),
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Saisis ton email pour recevoir\nun lien de réinitialisation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1B3A2D).withValues(alpha:0.45),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 36),

                  EmailField(controller: emailController),

                  const SizedBox(height: 24),

                  PrimaryButton(
                    label: 'Envoyer le lien',
                    onPressed: _loading ? () {} : _sendResetEmail,
                    isLoading: _loading,
                  ),

                  const SizedBox(height: 22),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Retour à la connexion",
                      style: TextStyle(
                        color: const Color(0xFF1B3A2D),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
