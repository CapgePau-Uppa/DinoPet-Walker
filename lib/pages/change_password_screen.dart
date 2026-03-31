import 'package:dinopet_walker/widgets/fields/password_field.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/widgets/common/my_appbar.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: Myappbar(title: "Changer le mot de passe", showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const Icon(
                  Icons.lock_reset_outlined,
                  size: 100,
                  color: Color(0xFF4CAF50),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Votre nouveau mot de passe\ndoit etre différent de l'ancien",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF0B5D5E),
                  ),
                ),
            
                const SizedBox(height: 36),

                PasswordField(
                  label: "Ancien mot de passe",
                  controller: oldPasswordController,
                ),
                const SizedBox(height: 24),

                PasswordField(
                  label: "Nouveau mot de passe",
                  controller: newPasswordController,
                ),
                const SizedBox(height: 24),

                PasswordField(
                  label: "Confirmer le mot de passe",
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 60),

                PrimaryButton(label: "Enregistrer", onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
