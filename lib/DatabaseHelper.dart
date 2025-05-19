import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  void initDatabaseFactory() {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb; // Web
    } else {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi; // Desktop/Mobile
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habits.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    // Inicializa a factory correta antes de abrir
    initDatabaseFactory();

    // No web não tem path, só usar o nome do banco
    if (kIsWeb) {
      return await openDatabase(
        fileName,
        version: 1,
        onCreate: _createDB,
      );
    } else {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, fileName);
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        emoji TEXT,
        dias TEXT,
        concluido INTEGER NOT NULL DEFAULT 0,
        ultimaAtualizacao TEXT
      )
    ''');
  }

  Future<int> insertHabit(Map<String, dynamic> habit) async {
    final db = await database;
    return await db.insert('habits', habit);
  }

  Future<List<Map<String, dynamic>>> getHabits() async {
    final db = await database;
    return await db.query('habits');
  }

  Future<int> updateHabit(Map<String, dynamic> habit) async {
    final db = await database;
    return await db.update(
      'habits',
      habit,
      where: 'id = ?',
      whereArgs: [habit['id']],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}