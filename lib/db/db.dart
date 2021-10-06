import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> _getDb() async {
    return openDatabase("${getDatabasesPath()}/hacker-news.db", onCreate: (Database db, int version) {
      db.execute("CREATE TABLE Settings(key INT PRIMARY KEY, value TEXT)");
    }, version: 1);
  }

  static Future<int> insert(Map<String, Object> values, [String tableName = "Settings"]) async {
    var database = await _getDb();
    return database.insert(tableName, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object?>>> select([String tableName = "Settings"]) async {
    Database database = await _getDb();
    return database.query(tableName, columns: ['key', 'value']);
  }

  static Future<Map<String, Object?>?> first({String? where, List<Object?>? whereArgs, String tableName = "Settings"}) async {
    Database database = await _getDb();
    try {
      return (await database.query(tableName, columns: ['key', 'value'], where: where, whereArgs: whereArgs, limit: 1)).first;
    } on StateError catch (e) {
      return null;
    }
  }

  static Future<bool> delete({String primaryColumn = "id", required dynamic primaryColumnValue, String tableName = "Settings"}) async {
    Database database = await _getDb();
    return await database.delete(tableName, where: "$primaryColumn = ?", whereArgs: [primaryColumnValue]) != 0;
  }
}
