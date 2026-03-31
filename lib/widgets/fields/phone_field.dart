import 'package:flutter/material.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final Color? fillColor;

  const PhoneField({super.key, required this.controller, this.fillColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xFF1B3A2D).withValues(alpha: 0.05),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: "Numéro de téléphone",
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: const Icon(
            Icons.phone_outlined,
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
