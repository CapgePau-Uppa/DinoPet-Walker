import 'package:dinopet_walker/services/map/location_task_handler.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class BackgroundTrackingService {
  // Config de la notification et du service en arriere plan
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'dinopet_tracking',
        channelName: 'Suivi de trajet',
        channelDescription: 'DinoPet enregistre votre parcours en arrière plan',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(60000),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

   // Démarrer le service s'il n'est pas actif
  static Future<void> start() async {
    if (await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.startService(
      serviceId: 1000,
      notificationTitle: 'DinoPet - Suivi actif',
      notificationText: 'Votre trajet journalier est enregistré',
      callback: startBackgroundCallback,
    );
  }

  static Future<void> stop() async {
    if (!await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.stopService();
  }

  // Envoyer le nombre de pas au TaskHandler pour publication sur Firestore
  static void sendStepsToService(int steps) {
    FlutterForegroundTask.sendDataToTask({'steps': steps});
  }
}
