import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:test_ashkryab/core/providers/movie_provider/movie_local_source_impl.dart';

class SqlDataSource {
  static final SqlDataSource _instance = SqlDataSource._privateConstructor();

  late Database _database;

  SqlDataSource._privateConstructor();

  factory SqlDataSource() {
    return _instance;
  }

  Future<bool> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sql_db.db');

    // await deleteDatabase(path);

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(MovieLocalProviderImpl.sqlTableSchema);
    });

    return true;
  }

  Future<void> insertAll(
      String table, List<Map<String, Object?>> values) async {
    await Future.wait(values.map((e) {
      try {
        return _database.insert(table, e,
            conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (e) {
        return Future.value();
      }
    }));
  }

  Future<List<Map<String, Object?>>> query(String query) async {
    return await _database.rawQuery(query);
  }
}
