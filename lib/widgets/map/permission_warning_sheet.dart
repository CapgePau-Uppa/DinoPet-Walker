import 'package:flutter/material.dart';

class PermissionWarningSheet extends StatelessWidget {
  final bool batteryOk;
  final bool notifOk;
  final VoidCallback onRequestBattery;
  final VoidCallback onOpenNotificationSettings;

  const PermissionWarningSheet({
    super.key,
    required this.batteryOk,
    required this.notifOk,
    required this.onRequestBattery,
    required this.onOpenNotificationSettings,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFE65100),
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  'Permissions exigées',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Pour assurer le suivi de votre activité en arrière plan, veuillez accorder ces autorisations.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            if (!batteryOk) ...[
              _PermissionTile(
                icon: Icons.battery_charging_full,
                title: 'Optimisation batterie',
                subtitle: 'Permet le suivi continu en arrière plan.',
                actionLabel: 'Autoriser',
                onTap: () {
                  Navigator.pop(context);
                  onRequestBattery();
                },
              ),
              if (!notifOk) const SizedBox(height: 12),
            ],
            if (!notifOk)
              _PermissionTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Requises pour le service de suivi.',
                actionLabel: 'Paramètres',
                onTap: () {
                  Navigator.pop(context);
                  onOpenNotificationSettings();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE65100).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFE65100), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF004D40),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}
