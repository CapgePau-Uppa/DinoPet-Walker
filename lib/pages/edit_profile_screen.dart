import 'package:dinopet_walker/controllers/firestore/user_controller.dart';
import 'package:dinopet_walker/widgets/common/confirm_password_dialog.dart';
import 'package:dinopet_walker/widgets/common/form_label.dart';
import 'package:dinopet_walker/widgets/fields/phone_field.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:dinopet_walker/widgets/fields/email_field.dart';
import 'package:dinopet_walker/widgets/fields/username_field.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/widgets/common/my_appbar.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initFields();
  }

  void initFields() {
    final userController = context.read<UserController>();
    usernameController.text = userController.username;
    emailController.text = userController.email;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final userController = context.read<UserController>();

    // Mise a jour de username
    if (usernameController.text != userController.username) {
      final error = await userController.updateUsername(
        usernameController.text,
      );
      if (!mounted) return;
      if (error != null) {
        Toast.show(
          context: context,
          message: error,
          icon: Icons.highlight_off,
          color: const Color(0xFFC94A4A),
        );
        return;
      }
    }

    // Mise a jour de l'email
    if (emailController.text != userController.email) {
      final password = await ConfirmPasswordDialog.show(context);
      if (!mounted) return;
      if (password == null || password.isEmpty) return;

      final error = await userController.updateEmail(
        newEmail: emailController.text,
        password: password,
      );
      if (!mounted) return;
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
        message:
            "Un lien de vérification a été envoyé a ${emailController.text}",
        icon: Icons.email,
        color: const Color(0xFF4CAF50),
      );
      return;
    }

    Toast.show(
      context: context,
      message: "Profil mis a jour",
      icon: Icons.check_circle,
      color: const Color(0xFF4CAF50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: Myappbar(title: "Modifier le profil", showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                FormLabel(text: "Nom d'utilisateur"),
                UsernameField(
                  controller: usernameController,
                  fillColor: const Color(0xFF1B3A2D).withValues(alpha: 0.05),
                ),

                const SizedBox(height: 20),

                FormLabel(text: "Adresse email"),
                EmailField(
                  controller: emailController,
                  fillColor: const Color(0xFF1B3A2D).withValues(alpha: 0.05),
                ),

                const SizedBox(height: 20),

                FormLabel(text: "Numéro de téléphone"),
                PhoneField(
                  controller: phoneController,
                  fillColor: const Color(0xFF1B3A2D).withValues(alpha: 0.05),
                ),

                const SizedBox(height: 36),

                PrimaryButton(label: "Enregistrer", onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
