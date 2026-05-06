import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String initialCountryCode;
  final Color? fillColor;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<Country>? onCountryChanged; 

  const PhoneField({
    super.key,
    required this.controller,
    this.initialCountryCode = 'FR',
    this.fillColor,
    this.onChanged,
    this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      initialCountryCode: initialCountryCode,
      decoration: InputDecoration(
        hintText: "Numéro de téléphone",
        filled: true,
        fillColor: fillColor ?? const Color(0xFF1B3A2D).withValues(alpha:  0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        counterText: "",
      ),
      languageCode: "fr",
      onChanged: (phone) => onChanged?.call(phone),
      onCountryChanged: (country) => onCountryChanged?.call(country),
    );
  }
}
