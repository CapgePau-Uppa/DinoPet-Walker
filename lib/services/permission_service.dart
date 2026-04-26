import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final Health _health = Health();

  // Demander toutes les autorisations nécessaires.
  Future<void> requestAll() async {
    // Activité physique
    await Permission.activityRecognition.request();

    // Localisation 
    final locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }

    // Health Connect
    await _health.configure();
    await _health.requestAuthorization(
      [HealthDataType.STEPS],
      permissions: [HealthDataAccess.READ],
    );

    // Batterie 
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Notifications
    final notifStatus =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notifStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

  }

}
