import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  /// Retourne la position ou une erreur en String
  Future<(LatLng?, String?)> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return (null, 'La géolocalisation est désactivée sur cet appareil.');
      }

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return (null, 'Permission de localisation refusée.');
      }

      final position = await Geolocator.getCurrentPosition();
      return (LatLng(position.latitude, position.longitude), null);
    } catch (e) {
      return (null, 'Impossible de récupérer ta position.');
    }
  }
}
