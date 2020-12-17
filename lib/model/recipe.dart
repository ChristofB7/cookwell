import 'dart:typed_data';
import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/ingredient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:network_image_to_byte/network_image_to_byte.dart';

class Recipe {
  String dbId;
  int id;
  String name;
  List<Ingredient> ingredients;
  List<String> directions;
  Image image;
  Image urlImage;
  Uint8List byteImage;
  Duration cookingTime;
  Duration prepTime;
  num servingSize;
  List<String> categories;
  String notes = "";
  bool saved;

  Recipe(
      {this.id,
        @required this.name,
      @required this.ingredients,
      @required this.directions,
      this.image,
      this.cookingTime,
      this.prepTime,
      this.servingSize,
      this.categories,
      this.notes,
      this.saved});

  Map<String, dynamic> toMap() =>{
    DatabaseProvider.COLUMN_ID: id,
    DatabaseProvider.COLUMN_RECIPE_DBID: dbId,
    DatabaseProvider.COLUMN_NAME: name,
    DatabaseProvider.COLUMN_INGREDIENTS: json.encode(_encodeIngredients()),
    DatabaseProvider.COLUMN_DIRECTIONS: json.encode(directions),
    DatabaseProvider.COLUMN_IMAGE: byteImage,
    DatabaseProvider.COLUMN_COOKINGTIME: cookingTime.inMinutes,
    DatabaseProvider.COLUMN_PREPTIME: prepTime.inMinutes,
    DatabaseProvider.COLUMN_SERVINGSIZE: servingSize,
    DatabaseProvider.COLUMN_NOTES: notes,
    DatabaseProvider.COLUMN_SAVED: 1,
  };

  Recipe.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    dbId = map[DatabaseProvider.COLUMN_RECIPE_DBID];
    name = name = _capitalizeName(map[DatabaseProvider.COLUMN_NAME]);
    ingredients = _decodeIngredients(json.decode(map[DatabaseProvider.COLUMN_INGREDIENTS]));
    directions = _decodeDirections(json.decode(map[DatabaseProvider.COLUMN_DIRECTIONS]));
    image = _decodeImage(map[DatabaseProvider.COLUMN_IMAGE]);
    cookingTime = Duration(minutes: map[DatabaseProvider.COLUMN_COOKINGTIME]);
    prepTime = Duration(minutes: map[DatabaseProvider.COLUMN_PREPTIME]);
    servingSize = map[DatabaseProvider.COLUMN_SERVINGSIZE];
    notes = map[DatabaseProvider.COLUMN_NOTES];
    saved = map[DatabaseProvider.COLUMN_SAVED] == 1;
  }

  Recipe.fromDBMap(String id, Map<String, dynamic> map) {
    dbId = id;
    name = _capitalizeName(map[DatabaseProvider.COLUMN_NAME]);
    image = Image.network(map[DatabaseProvider.COLUMN_IMAGE]);
    ingredients = _decodeDBIngredients(map[DatabaseProvider.COLUMN_INGREDIENTS]);
    directions = _decodeDirections(map[DatabaseProvider.COLUMN_DIRECTIONS]);
    cookingTime = Duration(minutes: map[DatabaseProvider.COLUMN_COOKINGTIME]);
    prepTime = Duration(minutes: map[DatabaseProvider.COLUMN_PREPTIME]);
    servingSize = map[DatabaseProvider.COLUMN_SERVINGSIZE];
    notes = map[DatabaseProvider.COLUMN_NOTES];
    checkSaved();
    _encodeImage(map[DatabaseProvider.COLUMN_IMAGE]);
  }

  List<dynamic> toDynamicList () {
    return [
      id,
      dbId ?? "",
      name,
      json.encode(_encodeIngredients()),
      json.encode(directions),
      byteImage,
      cookingTime.inMinutes,
      prepTime.inMinutes,
      servingSize,
      notes,
      1];
  }

  Future<void> checkSaved() async {
    saved = await DatabaseProvider.checkDBRecipeSaved(dbId);
  }

  String _capitalizeName(String str) {
    List<String> improper = ["and", "or", "in", "the", "with", "without"];
    return str.split(" ").map((str) => !improper.contains(str) ? str[0].toUpperCase() + str.substring(1) : str).join(" ");
  }

  Future<void> _encodeImage(String url) async {
    byteImage = await networkImageToByte(url);
  }

  Image _decodeImage(Uint8List bytes) {
    byteImage = bytes;
    return Image.memory(byteImage);
  }

  List<Ingredient> _decodeDBIngredients(List<dynamic> ingredients) => ingredients.map((ingredient) => Ingredient.fromMap(ingredient)).toList();

  List<Ingredient> _decodeIngredients(List<dynamic> ingredients) => ingredients.map((ingredient) => Ingredient.fromMap(json.decode(ingredient))).toList();

  List<String> _decodeDirections(List<dynamic> directions) => directions.map((direction) => direction.toString()).toList();

  List<String> _encodeIngredients() => ingredients.map((ingredient) => json.encode(ingredient.toMap())).toList();

  Future<bool> checkInDatabase () async => await DatabaseProvider.checkRecipeSaved(id);
}