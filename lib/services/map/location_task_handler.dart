import 'dart:async';
import 'package:dinopet_walker/models/user/track_point.dart';
import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/services/map/location_sharing_service.dart';
import 'package:dinopet_walker/sqlite/dao/track_point_dao.dart';
import 'package:dinopet_walker/utils/date_formatter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// Point d'entrée du service (appelé par Android/Ios pour démarrer le TaskHandler)
@pragma('vm:entry-point')
void startBackgroundCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionSub;
  TrackPointDao? _dao;
  AuthService? _authService;
  LocationSharingService? _sharingService;
  int _currentSteps = 0;

  // Initialiser firebase et les services, puis démarrer l'écoute Gps
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    final apps = Firebase.apps;
    if (apps.isEmpty) {
      await Firebase.initializeApp();
    }

    _dao = TrackPointDao();
    _authService = AuthService();
    _sharingService = LocationSharingService();

    _startGps();
  }

  // Démarrer le stream Gps et traiter chaque nouvelle position reçue
  void _startGps() {
    _positionSub?.cancel();
    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((position) async {
          // Ignorer les positions trop imprécises
          if (position.accuracy > 25) return;

          final uid = _authService?.getCurrentUser()?.uid;
          if (uid == null) return;

          final point = LatLng(position.latitude, position.longitude);

          await _dao?.insert(
            TrackPoint(
              uid: uid,
              date: DateFormater.todayString(),
              latitude: position.latitude,
              longitude: position.longitude,
              timestamp: DateTime.now(),
            ),
          );

          await _sharingService?.publishPositionAndCurrentSteps(
            position: point,
            dailySteps: _currentSteps,
          );

          await FlutterForegroundTask.updateService(
            notificationTitle: 'DinoPet — Suivi actif',
            notificationText: 'Votre trajet journalier est enregistré',
          );

          // Envoyer la mise a jour de la position à l'interface'
          FlutterForegroundTask.sendDataToMain({
            'lat': position.latitude,
            'lng': position.longitude,
            'accuracy': position.accuracy,
          });
        });
  }

  // Vérifier que le stream Gps est toujours actif
  @override
  void onRepeatEvent(DateTime timestamp) {
    if (_positionSub == null) _startGps();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _positionSub?.cancel();
    _positionSub = null;
  }

   // Recevoir les pas depuis l'interface et met à jour la valeur locale
  @override
  void onReceiveData(Object data) {
    if (data is Map && data['steps'] is int) {
      _currentSteps = data['steps'];
    }
  }

  // Lancer l'app en tapant sur la notif
  @override
  void onNotificationPressed() => FlutterForegroundTask.launchApp();

  @override
  void onNotificationDismissed() {}
}
