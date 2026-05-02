import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final Health _health = Health();

  /*
  // Demander toutes les autorisations nécessaires. 
  // On n'utilise plus cette fonction pour le moment
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

  }*/

  // Vérifier spécifiquement les deux permissions pour Home screen
  Future<Map<String, bool>> checkHomePermissions() async {
    bool activity = false;
    bool health = false;

    if (Platform.isAndroid) {
      activity = await Permission.activityRecognition.isGranted;

      await _health.configure();
      health =
          await _health.hasPermissions(
            [HealthDataType.STEPS],
            permissions: [HealthDataAccess.READ],
          ) ??
          false;

    } else if (Platform.isIOS) {
      activity = true;
      health = true;
    }

    return {'activity': activity, 'health': health};
  }

  // Vérifier la permission obligatoire pour Map screen
  Future<Map<String, bool>> checkMapPermissions() async {
    final location = await Permission.location.isGranted;
    return {'location': location};
  }

  // Vérifier les permessions nécessaires pour le suivi en arrière plan (pas obligatoires pour Map screen)
  Future<Map<String, bool>> checkWarningPermissions() async {
    final batteryOk =
        await FlutterForegroundTask.isIgnoringBatteryOptimizations;

    final notifStatus =
        await FlutterForegroundTask.checkNotificationPermission();
    final notifOk = notifStatus == NotificationPermission.granted;

    return {'battery': batteryOk, 'notification': notifOk};
  }

  Future<void> requestBattery() async {
    await FlutterForegroundTask.requestIgnoreBatteryOptimization();
  }

}
