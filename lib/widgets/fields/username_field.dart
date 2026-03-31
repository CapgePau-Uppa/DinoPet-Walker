import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  final Color? fillColor;

  const UsernameField({super.key, required this.controller, this.fillColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: fillColor ?? Colors.white70,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Nom d'utilisateur",
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF1B3A2D),
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
