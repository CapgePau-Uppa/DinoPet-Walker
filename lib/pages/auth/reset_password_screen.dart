import 'package:dinopet_walker/controllers/auth/reset_password_controller.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:dinopet_walker/widgets/fields/password_field.dart';
import 'package:dinopet_walker/pages/auth/auth_wrapper.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String oobCode;

  const ResetPasswordScreen({required this.oobCode, super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController _controller = ResetPasswordController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _loading = false;

  void confirmReset() async {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    final error = await _controller.confirmReset(
      oobCode: widget.oobCode,
      password: _passwordController.text.trim(),
      confirm: _confirmController.text.trim(),
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
      message: "Mot de passe rénitialisé",
      icon: Icons.check_circle,
      color: const Color(0xFF4CAF50),
    );
    
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 217, 255, 222),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  height -
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
                    "Nouveau \n mot de passe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1B3A2D),
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Choisis un mot de passe sécurisé",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1B3A2D).withValues(alpha:0.45),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 36),

                  PasswordField(
                    controller: _passwordController,
                    label: 'Nouveau mot de passe',
                  ),
                  const SizedBox(height: 14),
                  PasswordField(
                    controller: _confirmController,
                    label: 'Confirmer votre mot de passe',
                  ),

                  const SizedBox(height: 28),

                  PrimaryButton(
                    label: 'Réinitialiser',
                    onPressed: _loading ? () {} : confirmReset,
                    isLoading: _loading,
                  ),

                  const SizedBox(height: 10),

                  PrimaryButton(
                    label: 'Annuler',
                    onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const AuthWrapper(),
                              ),
                              (route) => false,
                            );
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
