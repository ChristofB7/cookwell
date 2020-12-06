import 'dart:io';

import 'package:cookwell/model/recipe.dart';
import 'package:cookwell/model/shopping_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseProvider {
  static const DB_NAME = "cookwell_db";
  static const DB_VERSION = 1;

  static const TABLE_SHOPPING = "shopping";
  static const COLUMN_SHOP_ID = "id";
  static const COLUMN_ITEM = "name";
  static const COLUMN_QUANTITY = "quantity";
  static const COLUMN_CHECKED = "checked";

  static const TABLE_RECIPES = "recipes";
  static const COLUMN_RECIPE_ID = "id";
  static const COLUMN_NAME = "name";
  static const COLUMN_INGREDIENTS = "ingredients";
  static const COLUMN_DIRECTIONS = "directions";
  //static const COLUMN_IMAGE = "image";
  static const COLUMN_COOKINGTIME = "cookingTime";
  static const COLUMN_PREPTIME = "prepTime";
  static const COLUMN_SERVINGSIZE = "servingSize";
  static const COLUMN_NOTES = "notes";
  static const COLUMN_SAVED = "saved";

  Future<void> createTable(Database db) async {
    await db.execute(
        '''
      CREATE TABLE $TABLE_SHOPPING (
          $COLUMN_SHOP_ID INTEGER PRIMARY KEY,
          $COLUMN_ITEM TEXT,
          $COLUMN_QUANTITY INTEGER,
          $COLUMN_CHECKED INTEGER
          )
          '''
    );

    await db.execute('''
            CREATE TABLE $TABLE_RECIPES (
          $COLUMN_RECIPE_ID INTEGER PRIMARY KEY,
          $COLUMN_NAME TEXT,
          $COLUMN_INGREDIENTS TEXT,
          $COLUMN_DIRECTIONS TEXT,
          $COLUMN_COOKINGTIME INTEGER,
          $COLUMN_PREPTIME INTEGER,
          $COLUMN_SERVINGSIZE REAL,
          $COLUMN_NOTES TEXT, 
          $COLUMN_SAVED INTEGER
          )
          ''');

    //$COLUMN_IMAGE TEXT,
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
    WHERE $COLUMN_SHOP_ID = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    return ShoppingItem.fromMap(data.first);

  }

  static Future<void> addShoppingItem(ShoppingItem item) async {
    final sql = '''INSERT INTO $TABLE_SHOPPING
    (
      $COLUMN_SHOP_ID,
      $COLUMN_ITEM,
      $COLUMN_QUANTITY,
      $COLUMN_CHECKED
    )
    VALUES (?,?,?,?)''';
    await db.rawInsert(sql, [item.id, item.item, item.quantity, item.checked ? 1: 0]);
  }

  static Future<void> deleteShoppingItem(ShoppingItem item) async {
    await db.delete(TABLE_SHOPPING,
        where: '$COLUMN_SHOP_ID = ?',
        whereArgs: [item.id]);
  }

  static Future<void> updateShoppingItem(ShoppingItem item) async {
    await db.update(TABLE_SHOPPING, item.toMap(),
        where: '$COLUMN_SHOP_ID = ?',
        whereArgs: [item.id]);
  }

  static Future<void> toggleItem(ShoppingItem item) async {
    ShoppingItem toggle = new ShoppingItem(
        id: item.id,
        item: item.item,
        quantity: item.quantity,
        checked: !item.checked);

    await db.update(TABLE_SHOPPING, toggle.toMap(),
        where: '$COLUMN_SHOP_ID = ?', whereArgs: [item.id]);
  }

  static Future<List<Recipe>> getRecipes() async {
    final data = await db.rawQuery("SELECT * FROM $TABLE_RECIPES");
    return data.isNotEmpty ? data.toList().map((c) => Recipe.fromMap(c)).toList() : null;
  }

  static Future<Recipe> getRecipe(int id) async {

    final sql = '''SELECT * FROM $TABLE_RECIPES
    WHERE $COLUMN_RECIPE_ID = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    return Recipe.fromMap(data.first);
  }

  static Future<List<Recipe>> searchRecipes(String query) async {

    final sql = '''SELECT * FROM $TABLE_RECIPES
    WHERE $COLUMN_NAME LIKE ?''';

    List<dynamic> params = ['%' + query + '%'];
    final data = await db.rawQuery(sql, params);

    List<Recipe> list =
    data.isNotEmpty ? data.toList().map((c) => Recipe.fromMap(c)).toList() : null;

    return list;
  }

  static Future<void> addRecipe(Recipe recipe) async {
    final sql = '''INSERT INTO $TABLE_RECIPES
    (
      $COLUMN_RECIPE_ID,
      $COLUMN_NAME,
      $COLUMN_INGREDIENTS,
      $COLUMN_DIRECTIONS,
      $COLUMN_COOKINGTIME,
      $COLUMN_PREPTIME,
      $COLUMN_SERVINGSIZE,
      $COLUMN_NOTES,
      $COLUMN_SAVED
    )
    VALUES (?,?,?,?,?,?,?,?, 1)''';
    //$COLUMN_IMAGE,

    await db.rawInsert(sql, recipe.toDynamicList());

  }

  static Future<void> deleteRecipe(Recipe recipe) async {
    await db.delete(TABLE_RECIPES,
        where: '$COLUMN_RECIPE_ID = ?',
        whereArgs: [recipe.id]);
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    await db.update(TABLE_RECIPES, recipe.toMap(),
        where: '$COLUMN_RECIPE_ID = ?',
        whereArgs: [recipe.id]);
  }

  static Future<bool> checkRecipeSaved(int id) async {
    final sql = '''SELECT * FROM $TABLE_RECIPES
    WHERE $COLUMN_RECIPE_ID = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    return data.isNotEmpty;
  }
}
