import 'package:dinopet_walker/pages/SelectionScreen.dart';
import 'package:dinopet_walker/pages/SignUpScreen.dart';
import 'package:dinopet_walker/widgets/common/PrimaryButton.dart';
import 'package:dinopet_walker/widgets/login/EmailField.dart';
import 'package:dinopet_walker/widgets/login/PasswordField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
  }

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
                          EmailField(controller:emailController,),
                          const SizedBox(height: 14),
                          PasswordField(controller: passwordController ,),
                          const SizedBox(height: 5),
                          
                          Center(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Mot de passe oublié ?",
                                style: TextStyle(
                                  color: Color(0xFF004D40),
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          PrimaryButton(
                            label: 'Se connecter',
                            onPressed: () => login(),
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color(0xFF004D40),
                                  fontSize: 13,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Pas encore de compte ? ",
                                  ),
                                  TextSpan(
                                    text: "S'inscrire",
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SignUpScreen(),
                                          ),
                                        );
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
                                    "Continuer avec Google",
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
