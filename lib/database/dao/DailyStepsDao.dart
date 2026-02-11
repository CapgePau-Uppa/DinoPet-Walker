import 'package:dinopet_walker/database/DatabaseHelper.dart';
import 'package:dinopet_walker/models/DailySteps.dart';
import 'package:sqflite/sqflite.dart';

class DailyStepsDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insert(DailySteps dailySteps) async {
    final db = await _dbHelper.database;
    await db.insert(
      'daily_steps',
      dailySteps.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DailySteps?> getByDate(String date) async {
    final db = await _dbHelper.database;
    final data = await db.query(
      'daily_steps',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (data.isEmpty) return null;
    return DailySteps.fromMap(data.first);
  }

  Future<List<DailySteps>> getLastDays(int days) async {
    final db = await _dbHelper.database;
    final data = await db.query(
      'daily_steps',
      orderBy: 'date DESC',
      limit: days,
    );
    return data.map(DailySteps.fromMap).toList();
  }
}
