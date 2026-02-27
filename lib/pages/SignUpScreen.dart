import 'package:dinopet_walker/pages/SelectionScreen.dart';
import 'package:dinopet_walker/widgets/common/PrimaryButton.dart';
import 'package:dinopet_walker/widgets/login/EmailField.dart';
import 'package:dinopet_walker/widgets/login/PasswordField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB2DFDB), Color(0xFF81C784)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    Image.asset(
                      "assets/logos/login_screen_logo.png",
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Nom d'utilisateur",
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: const Icon(Icons.person_outline),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const EmailField(),
                          const SizedBox(height: 14),
                          const PasswordField(),
                          const SizedBox(height: 14),
                          const PasswordField(),
                          const SizedBox(height: 30),
                          PrimaryButton(
                            label: "Créer un compte",
                            onPressed: () {
                              
                            },
                          ),
                          
                          const SizedBox(height: 20,),                          

                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color(0xFF004D40),
                                  fontSize: 13,
                                ),
                                children: [
                                  const TextSpan(text: "Déjà un compte ? "),
                                  TextSpan(
                                    text: "Se connecter",
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Color(0xFF004D40).withOpacity(0.4),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  "ou",
                                  style: TextStyle(
                                    color: Color(0xFF004D40).withOpacity(0.4),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Color(0xFF004D40).withOpacity(0.4),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF004D40),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
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
                                      color: Color(0xFF004D40),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "S'inscrire avec Google",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF004D40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
