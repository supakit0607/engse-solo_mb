import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/waste_point.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('waste_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE waste_points (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        location TEXT NOT NULL,
        note TEXT
      )
    ''');
  }

  // เติมฟังก์ชัน create เพื่อให้บันทึกข้อมูลได้จริง
  Future<int> create(WastePoint point) async {
    final db = await instance.database;
    return await db.insert('waste_points', point.toMap());
  }

  // แก้ไขฟังก์ชัน readAllPoints ตรงส่วนของ note
  Future<List<WastePoint>> readAllPoints() async {
    final db = await instance.database;
    final result = await db.query('waste_points');
    return result
        .map(
          (json) => WastePoint(
            id: json['id'] as int?,
            title: json['title'] as String,
            type: json['type'] as String,
            location: json['location'] as String,
            // แก้ไขตรงนี้: ใช้ as String? เพื่อรองรับค่าว่าง และเติม ?? '' เพื่อป้องกัน Error
            note: json['note'] as String? ?? '',
          ),
        )
        .toList();
  }
}
