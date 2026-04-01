import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.title,
    required this.icon,
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF0B6666).withValues(alpha: 0.001),
              width: 1.2,
            ),
          ),
          child: Container(
            height: height * 0.070,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: const Border(
                left: BorderSide(color: Color(0xFF0B6666), width: 10),
              ),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0B6666).withValues(alpha: .12),
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
                    color: Color(0xFF0B6666),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 22, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B6666),
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: Color(0xFF0B6666),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
