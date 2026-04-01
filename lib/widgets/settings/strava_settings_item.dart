import 'package:flutter/material.dart';

class StravaSettingsItem extends StatelessWidget {
  final bool isLinked;
  final VoidCallback onTap;

  const StravaSettingsItem({
    super.key,
    required this.isLinked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: const Color(0xFFFC4C02).withValues(alpha: 0.1),
        child: Container(
          height: height * 0.070,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),

            border: const Border(
              left: BorderSide(
                color: Color(0xFFFC4C02),
                width: 12,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFC4C02).withValues(alpha: .12),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: width * 0.1,
                height: width * 0.1,
                decoration: const BoxDecoration(
                  color: Color(0xFFFC4C02),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_run,
                  size: 18,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  "Strava",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B6666),
                  ),
                ),
              ),

              Row(
                children: [
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
                      fontWeight: FontWeight.w600,
                      color: isLinked
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFE24B4A),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: Color(0xFF0B6666),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
