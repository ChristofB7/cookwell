import 'package:cookwell/model/ingredient.dart';
import 'package:cookwell/model/unit.dart';
import './recipe.dart';
import 'package:flutter/material.dart';

var dummy_recipes = [
  Recipe(name: 'Hotdogs', ingredients: [
    Ingredient(
      name: "hotdog",
      amount: 1,
    ),
    Ingredient(
      name: "hotdog bun",
      amount: 1,
    ),
  ], directions: [
    "Cook hotdog.",
    "Put hotdog in bun.",
    "Garnish.",
  ],
  image: Image.network('https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/hotdog-royalty-free-image-185123377-1562609410.jpg'),
  cookingTime: Duration (minutes: 5),
  prepTime: Duration (minutes: 5),
  servingSize: 1,
  ),
  Recipe(name: 'Pasta', ingredients: [
    Ingredient(
      name: "pasta",
      amount: 1,
      unit: Unit.cup,
    ),
    Ingredient(
      name: "butter",
      unit: Unit.tablespoon,
      amount: 1,
    ),
    Ingredient(
      name: "parmesan",
      unit: Unit.cup,
      amount: 0.25,
    ),
  ], directions: [
    "Cook Pasta",
    "Put butter",
    "Garnish.",
  ],
    image: Image.network('https://hips.hearstapps.com/hmg-prod/images/buttered-noodles-horizontal-1545494266.png'),
    cookingTime: Duration (minutes: 10),
    prepTime: Duration (minutes: 5),
    servingSize: 2,
  ),
  Recipe(name: 'Hotdogs', ingredients: [
    Ingredient(
      name: "hotdog",
      amount: 1,
    ),
    Ingredient(
      name: "hotdog bun",
      amount: 1,
    ),
  ], directions: [
    "Cook hotdog.",
    "Put hotdog in bun.",
    "Garnish.",
  ],
    image: Image.network('https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/hotdog-royalty-free-image-185123377-1562609410.jpg'),
    cookingTime: Duration (minutes: 5),
    prepTime: Duration (minutes: 5),
    servingSize: 1,
  ),
  Recipe(name: 'Pasta', ingredients: [
    Ingredient(
      name: "pasta",
      amount: 1,
      unit: Unit.cup,
    ),
    Ingredient(
      name: "butter",
      unit: Unit.tablespoon,
      amount: 1,
    ),
    Ingredient(
      name: "parmesan",
      unit: Unit.cup,
      amount: 0.25,
    ),
  ], directions: [
    "Cook Pasta",
    "Put butter",
    "Garnish.",
  ],
    image: Image.network('https://hips.hearstapps.com/hmg-prod/images/buttered-noodles-horizontal-1545494266.png'),
    cookingTime: Duration (minutes: 10),
    prepTime: Duration (minutes: 5),
    servingSize: 2,
  ),
  Recipe(name: 'Hotdogs', ingredients: [
    Ingredient(
      name: "hotdog",
      amount: 1,
    ),
    Ingredient(
      name: "hotdog bun",
      amount: 1,
    ),
  ], directions: [
    "Cook hotdog.",
    "Put hotdog in bun.",
    "Garnish.",
  ],
    image: Image.network('https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/hotdog-royalty-free-image-185123377-1562609410.jpg'),
    cookingTime: Duration (minutes: 5),
    prepTime: Duration (minutes: 5),
    servingSize: 1,
  ),
  Recipe(name: 'Pasta', ingredients: [
    Ingredient(
      name: "pasta",
      amount: 1,
      unit: Unit.cup,
    ),
    Ingredient(
      name: "butter",
      unit: Unit.tablespoon,
      amount: 1,
    ),
    Ingredient(
      name: "parmesan",
      unit: Unit.cup,
      amount: 0.25,
    ),
  ], directions: [
    "Cook Pasta",
    "Put butter",
    "Garnish.",
  ],
    image: Image.network('https://hips.hearstapps.com/hmg-prod/images/buttered-noodles-horizontal-1545494266.png'),
    cookingTime: Duration (minutes: 10),
    prepTime: Duration (minutes: 5),
    servingSize: 2,
  ),
  Recipe(name: 'Hotdogs', ingredients: [
    Ingredient(
      name: "hotdog",
      amount: 1,
    ),
    Ingredient(
      name: "hotdog bun",
      amount: 1,
    ),
  ], directions: [
    "Cook hotdog.",
    "Put hotdog in bun.",
    "Garnish.",
  ],
    image: Image.network('https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/hotdog-royalty-free-image-185123377-1562609410.jpg'),
    cookingTime: Duration (minutes: 5),
    prepTime: Duration (minutes: 5),
    servingSize: 1,
  ),
  Recipe(name: 'Pasta', ingredients: [
    Ingredient(
      name: "pasta",
      amount: 1,
      unit: Unit.cup,
    ),
    Ingredient(
      name: "butter",
      unit: Unit.tablespoon,
      amount: 1,
    ),
    Ingredient(
      name: "parmesan",
      unit: Unit.cup,
      amount: 0.25,
    ),
  ], directions: [
    "Cook Pasta",
    "Put butter",
    "Garnish.",
  ],
    image: Image.network('https://hips.hearstapps.com/hmg-prod/images/buttered-noodles-horizontal-1545494266.png'),
    cookingTime: Duration (minutes: 10),
    prepTime: Duration (minutes: 5),
    servingSize: 2,
  ),
];
