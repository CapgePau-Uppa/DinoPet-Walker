import 'package:dinopet_walker/widgets/settings/profile/input_field.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/widgets/common/my_appbar.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, 
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
            children: [
              const SizedBox(height: 50),
              InputField(
                label: "Nom d'utilisateur",
                controller: usernameController,
              ),
              const SizedBox(height: 20),
              InputField(
                label: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              InputField(
                label: "Numéro de téléphone",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 40),
              PrimaryButton(label: "Enregistrer", onPressed: () {}),
            ],
          ),
        ),
      ),
              ),
    );
  }
}
