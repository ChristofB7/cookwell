import 'package:cookwell/model/ingredient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Recipe {
  String name;
  List<Ingredient> ingredients;
  List<String> directions;
  Image image;
  Duration cookingTime;
  Duration prepTime;
  double servingSize;
  List<String> categories;

  Recipe(
      {@required this.name,
      @required this.ingredients,
      @required this.directions,
      this.image,
      this.cookingTime,
      this.prepTime,
      this.servingSize,
      this.categories});
}
