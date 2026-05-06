import 'package:dinopet_walker/models/user/track_point.dart';
import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/sqlite/dao/track_point_dao.dart';
import 'package:dinopet_walker/utils/date_formatter.dart';
import 'package:latlong2/latlong.dart';

class TrackingService {
  final TrackPointDao _dao = TrackPointDao();
  final AuthService _authService = AuthService();

  String? get _uid => _authService.getCurrentUser()?.uid;

  // Sauvegarder un point en local
  Future<void> savePoint(LatLng position) async {
    final uid = _uid;
    if (uid == null) return;

    await _dao.insert(
      TrackPoint(
        uid: uid,
        date: DateFormater.todayString(),
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      ),
    );
  }

  // Récupérer les points de la journée enregistrés depuis le début de la journée
  Future<List<LatLng>> getTodayTrack() async {
    final uid = _uid;
    if (uid == null) return [];

    final points = await _dao.getByUidAndDate(uid, DateFormater.todayString());
    return points.map((p) => LatLng(p.latitude, p.longitude)).toList();
  }

  // Supprimer les points de trajets dont la date est antérieure à aujourd'hui
  Future<void> cleanPastDays() async {
    final uid = _uid;
    if (uid == null) return;
    await _dao.deletePastDays(uid, DateFormater.todayString());
  }
}
