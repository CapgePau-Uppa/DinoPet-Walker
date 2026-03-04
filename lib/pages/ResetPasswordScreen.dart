import 'package:dinopet_walker/controllers/ResetPasswordController.dart';
import 'package:dinopet_walker/widgets/common/PrimaryButton.dart';
import 'package:dinopet_walker/widgets/login/AuthWrapper.dart';
import 'package:dinopet_walker/widgets/login/PasswordField.dart';
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

    setState(() {
      _loading = true;
    });

    final error = await _controller.confirmReset(
      oobCode: widget.oobCode,
      password: _passwordController.text.trim(),
      confirm: _confirmController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mot de passe mis à jour')));

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(
                      context,
                    ).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logos/login_screen_logo.png',
                      height: 180,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Nouveau mot de passe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PasswordField(
                      controller: _passwordController,
                      label: 'Nouveau mot de passe',
                    ),
                    const SizedBox(height: 15),
                    PasswordField(
                      controller: _confirmController,
                      label: 'Confirmer votre mot de passe',
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Réinitialiser',
                      onPressed: _loading ? () {} : confirmReset,
                      isLoading: _loading,
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
