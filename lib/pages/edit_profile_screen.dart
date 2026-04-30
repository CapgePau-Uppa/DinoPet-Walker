import 'package:dinopet_walker/controllers/user/user_controller.dart';
import 'package:dinopet_walker/utils/connectivity_helper.dart';
import 'package:dinopet_walker/utils/date_formatter.dart';
import 'package:dinopet_walker/widgets/common/confirm_password_dialog.dart';
import 'package:dinopet_walker/widgets/common/form_label.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:dinopet_walker/widgets/fields/email_field.dart';
import 'package:dinopet_walker/widgets/fields/phone_field.dart';
import 'package:dinopet_walker/widgets/fields/username_field.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/widgets/common/my_appbar.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:intl_phone_field/countries.dart';
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

  String _fullPhoneNumber = '';
  String _initialCountryCode = 'FR';

  @override
  void initState() {
    super.initState();
    initFields();
  }

  void initFields() {
    final userController = context.read<UserController>();
    usernameController.text = userController.username;
    emailController.text = userController.email;

    final savedPhone = userController.phone;
    if (savedPhone.isNotEmpty) {
      _fullPhoneNumber = savedPhone;
      _initialCountryCode = _countryCodeFromPhone(savedPhone);
      phoneController.text = _localNumberFromPhone(savedPhone);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  

  Future<void> _save() async {
    final hasInternet = await ConnectivityHelper.hasInternet();
    
    if (!mounted) return;

    if (!hasInternet) {
      Toast.show(
        context: context,
        message: "Connexion internet requise",
        icon: Icons.wifi_off,
        color: const Color(0xFFC94A4A),
      );
      return;
    }
    
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

    if (_fullPhoneNumber.isNotEmpty) {
      await userController.updatePhone(_fullPhoneNumber);
      if (!mounted) return;
    }

    Toast.show(
      context: context,
      message: "Profil mis a jour",
      icon: Icons.check_circle,
      color: const Color(0xFF4CAF50),
    );
  }

  String _countryCodeFromPhone(String fullNumber) {
    final sorted = List<Country>.of(countries)..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

    for (final country in sorted) {
      if (fullNumber.startsWith('+${country.dialCode}')) return country.code;
    }
    return 'FR';
  }

  String _localNumberFromPhone(String fullNumber) {
    final sorted = List<Country>.of(countries)..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

    for (final country in sorted) {
      final prefix = '+${country.dialCode}';
      if (fullNumber.startsWith(prefix)) {
        return fullNumber.substring(prefix.length);
      }
    }
    return fullNumber;
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
                const SizedBox(height: 30),

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
                  initialCountryCode: _initialCountryCode,
                  fillColor: const Color(0xFF1B3A2D).withValues(alpha: 0.05),
                  onChanged: (phone) {
                    _fullPhoneNumber = phone.completeNumber;
                  },
                  onCountryChanged: (country) {
                    _fullPhoneNumber = '+${country.dialCode}${phoneController.text}';
                  },
                ),

                const SizedBox(height: 40),

                PrimaryButton(label: "Enregistrer", onPressed: _save),

                const SizedBox(height: 16),

                Center(
                  child: Consumer<UserController>(
                    builder: (context, userController, _) {
                      final createdAt = userController.createdAt;
                      if (createdAt == null) return const SizedBox.shrink();

                      return Text(
                        "Membre depuis le ${DateFormater.formatDate(createdAt)}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
