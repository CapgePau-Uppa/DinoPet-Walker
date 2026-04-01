import 'package:flutter/material.dart';

class StravaBottomSheet extends StatelessWidget {
  final bool isLinked;
  final bool isLoading;
  final VoidCallback onToggle;

  const StravaBottomSheet({
    super.key,
    required this.isLinked,
    required this.isLoading,
    required this.onToggle,
  });

  static void show(
    BuildContext context, {
    required bool isLinked,
    required bool isLoading,
    required VoidCallback onToggle,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StravaBottomSheet(
        isLinked: isLinked,
        isLoading: isLoading,
        onToggle: onToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFC4C02),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 5),
                    const Text(
                      "Strava",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/logos/strava_logo.png',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLinked
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE24B4A),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isLinked ? "Connecté" : "Non connecté",
                style: TextStyle(
                  fontSize: 13,
                  color: isLinked
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE24B4A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            isLinked
                ? "Votre compte est lié a strava."
                : "Liez votre compte pour importer vos activités.",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                      onToggle();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isLinked
                    ? Colors.grey[600]
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
                  : Icon(
                      isLinked ? Icons.link_off : Icons.link,
                      color: Colors.white,
                    ),
              label: Text(
                isLinked ? "Déconnecter" : "Connecter mon compte",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
