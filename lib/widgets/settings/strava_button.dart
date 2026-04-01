import 'package:flutter/material.dart';

class StravaButton extends StatelessWidget {
  final bool isLinked;
  final bool isLoading;
  final VoidCallback onTap;

  const StravaButton({
    super.key,
    required this.isLinked,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity,
      height: height * 0.06,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLinked
              ? Colors.grey[700]
              : const Color(0xFFFC4C02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(isLinked ? Icons.link_off : Icons.link, color: Colors.white),
        label: Text(
          isLinked ? "Déconnecter Strava" : "Lier mon compte Strava",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
