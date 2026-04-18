import 'dart:async';
import 'package:dinopet_walker/models/user/user_model.dart';
import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/services/map/location_service.dart';
import 'package:dinopet_walker/services/map/tracking_service.dart';
import 'package:dinopet_walker/services/map/location_sharing_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum MapStatus { loading, success, error }

class MapScreenController extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final TrackingService _trackingService = TrackingService();
  final AuthService _authService = AuthService();
  final LocationSharingService _locationSharingService = LocationSharingService();

  MapStatus _status = MapStatus.loading;
  LatLng? _userPosition;
  List<LatLng> _dailyPath = [];
  List<UserModel> _otherUsers = [];
  int _currentSteps = 0;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<List<UserModel>>? _otherUsersStream;
  StreamSubscription<User?>? _authStream;

  MapStatus get status => _status;
  LatLng? get userPosition => _userPosition;
  List<LatLng> get dailyPath => List.unmodifiable(_dailyPath);
  List<UserModel> get otherUsers => List.unmodifiable(_otherUsers);

  MapScreenController({required int currentSteps})
    : _currentSteps = currentSteps {
    // S'il l'utilisateur se déconnecte on libère les streams
    _authStream = _authService.authStateChanges().listen((user) {
      if (user == null) {
        _cancelStreams();
      }
    });
  }

  Future<String?> init() async {
    _status = MapStatus.loading;
    notifyListeners();

    await _trackingService.cleanPastDays();

    final (position, error) = await _locationService.getCurrentPosition();

    if (error != null) {
      _status = MapStatus.error;
      notifyListeners();
      return error;
    }

    _userPosition = position;
    _dailyPath = await _trackingService.getTodayTrack();

    _status = MapStatus.success;
    notifyListeners();

    _startTracking();
    _startWatchingOtherUsers();
    return null;
  }

  void _startTracking() {
    _positionStream?.cancel();
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            // Point émis après 5 mètres de déplacement
            distanceFilter: 5, 
          ),
        ).listen((position) async {
          // Ignorer les points avec un gps trop imprécis pour résoudre le problème d'instabilité qui survient parfois
          if (position.accuracy > 25) return;

          final newPoint = LatLng(position.latitude, position.longitude);
          _userPosition = newPoint;
          _dailyPath.add(newPoint);
          await _trackingService.savePoint(newPoint);
          await _locationSharingService.publishPositionAndCurrentSteps(
            position: newPoint,
            dailySteps: _currentSteps,
          );
          notifyListeners();
        });
  }

  void _startWatchingOtherUsers() {
    _otherUsersStream?.cancel();
    _otherUsersStream = _locationSharingService.watchOtherUsers().listen((
      users,
    ) {
      _otherUsers = users;
      notifyListeners();
    });
  }

  void updateSteps(int steps) {
    _currentSteps = steps;
  }

  void _cancelStreams() {
    _positionStream?.cancel();
    _positionStream = null;
    _otherUsersStream?.cancel();
    _otherUsersStream = null;
  }

  @override
  void dispose() {
    _cancelStreams();
    _authStream?.cancel();
    super.dispose();
  }
}
