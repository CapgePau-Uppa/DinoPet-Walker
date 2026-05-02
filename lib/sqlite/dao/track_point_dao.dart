import 'package:dinopet_walker/models/user/track_point.dart';
import 'package:dinopet_walker/sqlite/tracking_database_helper.dart';

class TrackPointDao {
  final TrackingDatabaseHelper _dbHelper = TrackingDatabaseHelper.instance;

  Future<void> insert(TrackPoint point) async {
    final db = await _dbHelper.database;
    await db.insert('track_points', point.toMap());
  }

  /// Points du jour pour un utilisateur donné
  Future<List<TrackPoint>> getByUidAndDate(String uid, String date) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'track_points',
      where: 'uid = ? AND date = ?',
      whereArgs: [uid, date],
      orderBy: 'timestamp ASC',
    );
    return rows.map(TrackPoint.fromMap).toList();
  }

  /// Supprime les points des jours précédents pour un utilisateur
  Future<void> deletePastDays(String uid, String today) async {
    final db = await _dbHelper.database;
    await db.delete(
      'track_points',
      where: 'uid = ? AND date < ?',
      whereArgs: [uid, today],
    );
  }
}
