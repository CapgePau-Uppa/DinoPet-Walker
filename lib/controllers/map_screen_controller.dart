import 'dart:async';

import 'package:dinopet_walker/services/location_service.dart';
import 'package:dinopet_walker/services/tracking_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum MapStatus { loading, success, error }

class MapScreenController extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final TrackingService _trackingService = TrackingService();

  MapStatus _status = MapStatus.loading;
  LatLng? _userPosition;
  List<LatLng> _dailyPath = [];
  StreamSubscription<Position>? _positionStream;

  MapStatus get status => _status;
  LatLng? get userPosition => _userPosition;
  List<LatLng> get dailyPath => List.unmodifiable(_dailyPath);

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
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
