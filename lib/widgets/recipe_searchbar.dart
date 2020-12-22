import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:cookwell/widgets/components/vertical_recipes_list.dart';
import 'package:flutter/material.dart';

import 'dart:core';

class RecipeSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: IconButton(
          icon: Icon(
            Icons.search,
            color: colorScheme.primary,
          ),
          onPressed: () {
            showSearch(context: context, delegate: RecipeSearchBarState());
          }),
    );
  }
}

// TODO: search by ingredients
// TODO: stateful searching

class RecipeSearchBarState extends SearchDelegate<String> {
  Future<List<Recipe>> localRecipes;
  Future<List<Recipe>> dbRecipes;

  RecipeSearchBarState() {
    this.localRecipes = DatabaseProvider.getRecipes();
    this.dbRecipes = DatabaseProvider.getFirebaseRecipes();
  }

  @override
  String get searchFieldLabel => 'Search recipe...';

  @override
  List<Widget> buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      IconButton(
          icon: Icon(Icons.clear, color: colorScheme.primary),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        Icons.arrow_back_outlined,
        color: colorScheme.primary,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildLists(localRecipes, dbRecipes, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final localRecipesList =
        query.isEmpty ? localRecipes : DatabaseProvider.searchRecipes(query.toLowerCase());
    final databaseRecipesList = query.isEmpty
        ? dbRecipes
        : DatabaseProvider.searchFirebaseRecipes(query.toLowerCase());
    return buildLists(localRecipesList, databaseRecipesList, context);
  }

  Column buildLists(Future<List<Recipe>> localRecipesList,
      Future<List<Recipe>> databaseRecipesList, BuildContext context) {
    return Column(
      children: [
        VerticalRecipesList(header: "MY COOKBOOK", list: localRecipesList),
        VerticalRecipesList(header: "ALL RECIPES", list: databaseRecipesList),
      ],
    );
  }
}
