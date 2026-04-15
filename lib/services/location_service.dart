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

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return (null, 'Permission de localisation refusée.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return (
          null,
          'Permission refusée définitivement.\nRéactivez la permession dans les paramètres de l\'application.',
        );
      }

      final position = await Geolocator.getCurrentPosition();
      return (LatLng(position.latitude, position.longitude), null);
    } catch (e) {
      return (null, 'Impossible de récupérer ta position.');
    }
  }
}
