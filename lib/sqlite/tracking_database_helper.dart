import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TrackingDatabaseHelper {
  static final TrackingDatabaseHelper instance = TrackingDatabaseHelper._init();
  static Database? _database;

  TrackingDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tracking.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filename);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE track_points (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        uid       TEXT NOT NULL,
        date      TEXT NOT NULL,
        latitude  REAL NOT NULL,
        longitude REAL NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
