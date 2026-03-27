import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'characters.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE characters (
            id INTEGER PRIMARY KEY,
            data TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE edits (
            id INTEGER PRIMARY KEY,
            data TEXT
          )
        ''');
      },
    );
  }
}
