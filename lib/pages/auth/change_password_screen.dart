import 'package:dinopet_walker/controllers/auth/change_password_controller.dart';
import 'package:dinopet_walker/utils/connectivity_helper.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';
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
  final ChangePasswordController _controller = ChangePasswordController();
  bool _loading = false;
  
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();


  void _submit() async {

    if (!await ConnectivityHelper.hasInternet()) {
      if (!mounted) return;
      Toast.show(
        context: context,
        message: "Connexion internet requise",
        icon: Icons.wifi_off,
        color: const Color(0xFFC94A4A),
      );
      return;
    }
    
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    final error = await _controller.changePassword(
      oldPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _loading = false);

    if (error != null) {
      Toast.show(
        context: context,
        message: error,
        icon: Icons.highlight_off,
        color: const Color(0xFFC94A4A),
      );
      return;
    }

    Toast.show(
      context: context,
      message: "Mot de passe modifié avec succès",
      icon: Icons.check_circle,
      color: const Color(0xFF4CAF50),
    );

    Navigator.pop(context);
  }

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
      appBar: Myappbar(title: "Changer le mot de passe", showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 40),

              SizedBox(
                width: 100,
                height: 100,       
                child: Image.asset("assets/icons/security_icon.png", height: 130),
              ),

              const SizedBox(height: 32),

              const Text(
                "Sécurité du compte",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B3A2D),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Votre nouveau mot de passe\ndoit être différent de l'ancien.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1B3A2D).withValues(alpha: 0.6),
                ),
              ),

              const SizedBox(height: 40),

              PasswordField(
                label: "Ancien mot de passe",
                controller: oldPasswordController,
                fillColor: Color(0xFF1B3A2D).withValues(alpha: 0.05),
              ),
              const SizedBox(height: 20),

              PasswordField(
                label: "Nouveau mot de passe",
                controller: newPasswordController,
                fillColor: Color(0xFF1B3A2D).withValues(alpha: 0.05),
              ),
              const SizedBox(height: 20),

              PasswordField(
                label: "Confirmer le mot de passe",
                controller: confirmPasswordController,
                fillColor: Color(0xFF1B3A2D).withValues(alpha: 0.05),
              ),

              const SizedBox(height: 48),

              PrimaryButton(
                label: "Réinitialiser",
                onPressed: _loading ? () {} : _submit,
                isLoading: _loading,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
