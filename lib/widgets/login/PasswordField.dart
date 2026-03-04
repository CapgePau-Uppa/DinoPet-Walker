import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isHide = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white70,
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _isHide,
        decoration: InputDecoration(
          hintText: widget.label,
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1B3A2D)),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _isHide = !_isHide),
            icon: Icon(
              _isHide
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF1B3A2D),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Color(0xFF1B3A2D), width: 1.5),
          ),
        ),
      ),
    );
  }
}
