import 'package:dinopet_walker/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum MapStatus { loading, success, error }

class MapScreenController extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  MapStatus _status = MapStatus.loading;
  LatLng? _userPosition;

  MapStatus get status => _status;
  LatLng? get userPosition => _userPosition;

  Future<String?> init() async {
    _status = MapStatus.loading;
    notifyListeners();

    final (position, error) = await _locationService.getCurrentPosition();

    if (error != null) {
      _status = MapStatus.error;
      notifyListeners();
      return error;
    }

    _userPosition = position;
    _status = MapStatus.success;
    notifyListeners();
    return null;
  }
}
