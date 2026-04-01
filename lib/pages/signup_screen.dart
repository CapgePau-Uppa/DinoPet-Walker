import 'package:dinopet_walker/controllers/authentification/signup_controller.dart';
import 'package:dinopet_walker/pages/email_verification_screen.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:dinopet_walker/widgets/fields/email_field.dart';
import 'package:dinopet_walker/widgets/fields/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _controller = SignUpController();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _loading = false;

  void _signUp() async {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    final erreur = await _controller.signUp(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (erreur != null) {
      Toast.show(
        context: context,
        message: erreur,
        icon: Icons.highlight_off,
        color: const Color(0xFFC94A4A),
      );
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 217, 255, 222),
      body: Stack(
        children: [
          SafeArea(
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

                      Image.asset(
                        "assets/logos/logo.png",
                        height: 110,
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        "Créer un compte",
                        style: TextStyle(
                          color: Color(0xFF1B3A2D),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Rejoins notre Team Dinopet !",
                        style: TextStyle(
                          color: const Color(0xFF1B3A2D).withValues(alpha:0.45),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 32),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white70,
                        ),
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: "Nom d'utilisateur",
                            filled: true,
                            fillColor: Colors.transparent,
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF1B3A2D),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Color(0xFF1B3A2D),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      EmailField(controller: emailController),

                      const SizedBox(height: 14),

                      PasswordField(
                        controller: passwordController,
                        label: 'Mot de passe',
                      ),

                      const SizedBox(height: 14),

                      PasswordField(
                        controller: confirmPasswordController,
                        label: 'Confirmer le mot de passe',
                      ),

                      const SizedBox(height: 28),

                      PrimaryButton(
                        label: "Créer un compte",
                        onPressed: _loading ? () {} : _signUp,
                        isLoading: _loading,
                      ),

                      const SizedBox(height: 22),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: const Color(0xFF1B3A2D).withValues(alpha:0.5),
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: "Déjà un compte ? "),
                            TextSpan(
                              text: "Se connecter",
                              style: const TextStyle(
                                color: Color(0xFF1B3A2D),
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF1B3A2D),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: const Color(0xFF1B3A2D).withValues(alpha: 0.12),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              "ou",
                              style: TextStyle(
                                color: const Color(0xFF1B3A2D).withValues(alpha:0.3),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: const Color(0xFF1B3A2D).withValues(alpha:0.12),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1B3A2D),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(
                                color: Color(0xFFE8E0D5),
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logos/google_logo.png',
                                height: 22,
                                width: 22,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.g_mobiledata_rounded,
                                  size: 26,
                                  color: Color(0xFF1B3A2D),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "S'inscrire avec Google",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
        ],
      ),
    );
  }
}
