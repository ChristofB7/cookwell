import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/ingredient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:network_image_to_byte/network_image_to_byte.dart';

class Recipe {
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
    DatabaseProvider.COLUMN_RECIPE_ID: id,
    DatabaseProvider.COLUMN_NAME: name,
    DatabaseProvider.COLUMN_INGREDIENTS: json.encode(encodeIngredients()),
    DatabaseProvider.COLUMN_DIRECTIONS: json.encode(directions),
    DatabaseProvider.COLUMN_IMAGE: byteImage,
    DatabaseProvider.COLUMN_COOKINGTIME: cookingTime.inMinutes,
    DatabaseProvider.COLUMN_PREPTIME: prepTime.inMinutes,
    DatabaseProvider.COLUMN_SERVINGSIZE: servingSize,
    DatabaseProvider.COLUMN_NOTES: notes,
    DatabaseProvider.COLUMN_SAVED: 1,
  };

  Recipe.fromMap(Map<String, dynamic> map)   {
    id = map[DatabaseProvider.COLUMN_RECIPE_ID];
    name = name = _capitalizeName(map[DatabaseProvider.COLUMN_NAME]);
    ingredients = decodeIngredients(json.decode(map[DatabaseProvider.COLUMN_INGREDIENTS]));
    directions = decodeDirections(json.decode(map[DatabaseProvider.COLUMN_DIRECTIONS]));
    image = decodeImage(map[DatabaseProvider.COLUMN_IMAGE]);
    cookingTime = Duration(minutes: map[DatabaseProvider.COLUMN_COOKINGTIME]);
    prepTime = Duration(minutes: map[DatabaseProvider.COLUMN_PREPTIME]);
    servingSize = map[DatabaseProvider.COLUMN_SERVINGSIZE];
    notes = map[DatabaseProvider.COLUMN_NOTES];
    saved = map[DatabaseProvider.COLUMN_SAVED] == 1;
  }

  List<dynamic> toDynamicList () {
    return [
      id,
      name,
      json.encode(encodeIngredients()),
      json.encode(directions),
      byteImage,
      cookingTime.inMinutes,
      prepTime.inMinutes,
      servingSize,
      notes,
      1];
  }

  List<Ingredient> decodeIngredients(List<dynamic> ingredients) {
    List<Ingredient> decodedList = new List();
    for(String ingredient in ingredients){
      decodedList.add(Ingredient.fromMap(json.decode(ingredient)));
    }
    return decodedList;
  }

  List<String> decodeDirections(List<dynamic> directions) {
    List<String> decodedList = new List();
    for(String direction in directions){
      decodedList.add(direction);
    }
    return decodedList;
  }

  List<String> encodeIngredients() {
    List<String> encodedList = new List();
    for (Ingredient ingredient in ingredients) {
      encodedList.add(json.encode(ingredient.toMap()));
    }
    return encodedList;
  }

  Image decodeImage(Uint8List bytes) {
    byteImage = bytes;
    return Image.memory(byteImage);
  }

  Future<bool> checkInDatabase () async {
    return await DatabaseProvider.checkRecipeSaved(id);
  }
}