import 'dart:io';

import 'package:cookwell/model/shopping_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class ShoppingDatabaseProvider {
  static const DB_NAME = "cookwell_db";
  static const DB_VERSION = 1;

  static const TABLE_SHOPPING = "shopping";
  static const COLUMN_ID = "id";
  static const COLUMN_ITEM = "name";
  static const COLUMN_QUANTITY = "quantity";
  static const COLUMN_CHECKED = "checked";

  Future<void> createTable(Database db) async {
    await db.execute(
        '''
      CREATE TABLE $TABLE_SHOPPING (
          $COLUMN_ID INTEGER PRIMARY KEY,
          $COLUMN_ITEM TEXT,
          $COLUMN_QUANTITY INTEGER,
          $COLUMN_CHECKED INTEGER
          )
          '''
    );
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath(DB_NAME);
    db = await openDatabase(path, version: DB_VERSION, onCreate: onCreate);
  }

  Future<void> onCreate(Database db, int version) async {
    await createTable(db);
  }


  static Future<List<ShoppingItem>> getShoppingList() async {
    final data = await db.rawQuery("SELECT * FROM $TABLE_SHOPPING");
    return data.isNotEmpty ? data.toList().map((c) => ShoppingItem.fromMap(c)).toList() : null;
  }

  static Future<List<ShoppingItem>> getCheckedItems() async {
    final data = await db.rawQuery("SELECT * FROM $TABLE_SHOPPING WHERE $COLUMN_CHECKED=1");
    List<ShoppingItem> list =
    data.isNotEmpty ? data.toList().map((c) => ShoppingItem.fromMap(c)).toList() : null;
    return list;
  }

  static Future<List<ShoppingItem>> getUncheckedItems() async {
    final data = await db.rawQuery("SELECT * FROM $TABLE_SHOPPING WHERE $COLUMN_CHECKED=0");
    List<ShoppingItem> list =
    data.isNotEmpty ? data.toList().map((c) => ShoppingItem.fromMap(c)).toList() : null;
    return list;
  }


  static Future<ShoppingItem> getShoppingItem(int id) async {

    final sql = '''SELECT * FROM $TABLE_SHOPPING
    WHERE $COLUMN_ID = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    return ShoppingItem.fromMap(data.first);

  }

  static Future<void> addShoppingItem(ShoppingItem item) async {
    final sql = '''INSERT INTO $TABLE_SHOPPING
    (
      $COLUMN_ID,
      $COLUMN_ITEM,
      $COLUMN_QUANTITY,
      $COLUMN_CHECKED
    )
    VALUES (?,?,?,?)''';
    await db.rawInsert(sql, [item.id, item.item, item.quantity, item.checked ? 1: 0]);
  }

  static Future<void> deleteShoppingItem(ShoppingItem item) async {
    await db.delete(TABLE_SHOPPING,
        where: '$COLUMN_ID = ?',
        whereArgs: [item.id]);
  }

  static Future<void> updateShoppingItem(ShoppingItem item) async {
    await db.update(TABLE_SHOPPING, item.toMap(),
        where: '$COLUMN_ID = ?',
        whereArgs: [item.id]);
  }

  static Future<void> toggleItem(ShoppingItem item) async {
    ShoppingItem toggle = new ShoppingItem(
        id: item.id,
        item: item.item,
        quantity: item.quantity,
        checked: !item.checked);

    await db.update(TABLE_SHOPPING, toggle.toMap(),
        where: '$COLUMN_ID = ?', whereArgs: [item.id]);
  }

}
