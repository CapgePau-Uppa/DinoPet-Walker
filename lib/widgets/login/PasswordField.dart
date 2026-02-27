import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isHide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isHide,
      decoration: InputDecoration(
        hintText: "Mot de passe",
        filled: true,
        fillColor: Colors.white70,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isHide = !_isHide;
            });
          },
          icon: Icon(
            _isHide ?  Icons.visibility_off_outlined: Icons.visibility_outlined
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
