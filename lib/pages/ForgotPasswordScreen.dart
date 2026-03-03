import 'package:dinopet_walker/controllers/ForgotPasswordController.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/widgets/login/EmailField.dart'; // Réutilisez le même composant
import 'package:dinopet_walker/widgets/common/PrimaryButton.dart'; // Même bouton

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController _controller = ForgotPasswordController();

  final TextEditingController emailController =
      TextEditingController(); 

  Future<void> _sendResetEmail() async {

    final error = await _controller.sendResetPasswordEmail(
      email: emailController.text.trim(),
    );

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email de réinitialisation envoyé'),
          backgroundColor: Colors.green,
        ),
      );
    }
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
            colors: [
              Color(0xFFB2DFDB),
              Color(0xFF81C784),
            ],
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
                          EmailField(controller: emailController),
                          const SizedBox(height: 32),
                          Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF004D40),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Saisissez votre email pour recevoir un lien.',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF004D40).withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                
                          PrimaryButton(
                            label:'Envoyer le lien',
                            onPressed: ()=> _sendResetEmail()
                          ),
                          const SizedBox(height: 20),
                
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Retour à la connexion",
                                style: TextStyle(
                                  color: const Color(0xFF004D40),
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
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
