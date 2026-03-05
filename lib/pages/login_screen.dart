import 'package:dinopet_walker/controllers/login_controller.dart';
import 'package:dinopet_walker/pages/forgot_password_screen.dart';
import 'package:dinopet_walker/pages/signup_screen.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:dinopet_walker/widgets/login/email_field.dart';
import 'package:dinopet_walker/widgets/login/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;

  void login() async {
    FocusScope.of(context).unfocus();

    setState(() => _loading = true);
    final error = await _controller.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    if (mounted) setState(() => _loading = false);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
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

                      Image.asset("assets/logos/logo.png", height: 130),

                      const SizedBox(height: 16),

                      const Text(
                        "Connexion",
                        style: TextStyle(
                          color: Color(0xFF1B3A2D),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Connecte toi pour continuer l'aventure",
                        style: TextStyle(
                          color: const Color(0xFF1B3A2D).withOpacity(0.45),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 36),

                      EmailField(controller: emailController),
                      const SizedBox(height: 14),
                      PasswordField(
                        controller: passwordController,
                        label: 'Mot de passe',
                      ),

                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ForgotPasswordScreen(),
                            ),
                          ),
                          child: const Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(
                              color: Color(0xFF1B3A2D),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      PrimaryButton(
                        label: 'Se connecter',
                        onPressed: _loading ? () {} : login,
                        isLoading: _loading,
                      ),

                      const SizedBox(height: 22),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: const Color(0xFF1B3A2D).withOpacity(0.5),
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: "Pas encore de compte ? "),
                            TextSpan(
                              text: "S'inscrire",
                              style: const TextStyle(
                                color: Color(0xFF1B3A2D),
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF1B3A2D),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpScreen(),
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: const Color(0xFF1B3A2D).withOpacity(0.12),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              "ou",
                              style: TextStyle(
                                color: const Color(0xFF1B3A2D).withOpacity(0.3),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: const Color(0xFF1B3A2D).withOpacity(0.12),
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
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.g_mobiledata_rounded,
                                  size: 26,
                                  color: Color(0xFF1B3A2D),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Continuer avec Google",
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
