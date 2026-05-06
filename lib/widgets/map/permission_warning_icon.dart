import 'package:dinopet_walker/controllers/map_screen_controller.dart';
import 'package:dinopet_walker/widgets/map/permission_warning_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PermissionWarningIcon extends StatelessWidget {
  const PermissionWarningIcon({super.key});

  void _openSheet(BuildContext context, MapScreenController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PermissionWarningSheet(
        batteryOk: controller.batteryOk,
        notifOk: controller.notifOk,
        onRequestBattery: controller.requestBattery,
        onOpenNotificationSettings: controller.openNotificationSettings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapScreenController>();

    if (!controller.hasWarnings) return const SizedBox.shrink();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      right: 16,
      child: GestureDetector(
        onTap: () => _openSheet(context, controller),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFE65100),
            size: 30,
          ),
        ),
      ),
    );
  }
}
