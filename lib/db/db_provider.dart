import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class LocalDatabaseProvider {
  static const TABLE_SHOPPING = "shopping";
  static const COLUMN_ITEM = "name";
  static const COLUMN_QUANTITY = "quantity";
  static const COLUMN_CHECKED = "checked";

  LocalDatabaseProvider._();
  static final LocalDatabaseProvider db = LocalDatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String path = await getDatabasesPath();

    return await openDatabase(
      join(path, 'cookwellDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute(
          "CREATE TABLE $TABLE_SHOPPING ("
          "$COLUMN_ITEM TEXT,"
          "$COLUMN_QUANTITY INTEGER,"
          "$COLUMN_CHECKED TEXT"
          ")",
        );
      },
    );
  }
}
