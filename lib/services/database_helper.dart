import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game_record.dart';

class DatabaseHelper {
  static const _databaseName = "tetris_records.db";
  static const _databaseVersion = 1;
  static const _tableName = 'game_records';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        score INTEGER NOT NULL,
        level INTEGER NOT NULL,
        lines INTEGER NOT NULL,
        date INTEGER NOT NULL,
        duration INTEGER NOT NULL
      )
    ''');
  }

  // Insert a new game record
  Future<int> insertRecord(GameRecord record) async {
    Database db = await database;
    return await db.insert(_tableName, record.toMap());
  }

  // Get all records ordered by score (descending)
  Future<List<GameRecord>> getAllRecords() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'score DESC',
    );
    
    return List.generate(maps.length, (i) {
      return GameRecord.fromMap(maps[i]);
    });
  }

  // Get top N records
  Future<List<GameRecord>> getTopRecords(int limit) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'score DESC',
      limit: limit,
    );
    
    return List.generate(maps.length, (i) {
      return GameRecord.fromMap(maps[i]);
    });
  }

  // Get personal best (highest score)
  Future<GameRecord?> getPersonalBest() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'score DESC',
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return GameRecord.fromMap(maps.first);
    }
    return null;
  }

  // Get game statistics
  Future<Map<String, dynamic>> getGameStats() async {
    Database db = await database;
    
    // Total games played
    List<Map<String, dynamic>> totalGames = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName'
    );
    
    // Average score
    List<Map<String, dynamic>> avgScore = await db.rawQuery(
      'SELECT AVG(score) as avg FROM $_tableName'
    );
    
    // Total lines cleared
    List<Map<String, dynamic>> totalLines = await db.rawQuery(
      'SELECT SUM(lines) as total FROM $_tableName'
    );
    
    // Total play time (in seconds)
    List<Map<String, dynamic>> totalTime = await db.rawQuery(
      'SELECT SUM(duration) as total FROM $_tableName'
    );

    return {
      'totalGames': totalGames.first['count'] ?? 0,
      'averageScore': (avgScore.first['avg'] ?? 0.0).round(),
      'totalLines': totalLines.first['total'] ?? 0,
      'totalPlayTime': totalTime.first['total'] ?? 0,
    };
  }

  // Delete a specific record
  Future<int> deleteRecord(int id) async {
    Database db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Clear all records
  Future<int> clearAllRecords() async {
    Database db = await database;
    return await db.delete(_tableName);
  }

  // Close database
  Future<void> close() async {
    Database db = await database;
    await db.close();
  }
}