import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:cookwell/widgets/recipe_tile.dart';
import 'package:flutter/material.dart';

import 'dart:core';

import 'header.dart';

class SearchRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return IconButton(
        icon: Icon(
          Icons.search,
          color: colorScheme.primary,
        ),
        onPressed: () {
          showSearch(context: context, delegate: _SearchRecipeState());
        });
  }
}

// TODO: search by ingredients

class _SearchRecipeState extends SearchDelegate<String> {
  Future<List<Recipe>> localRecipes;
  Future<List<Recipe>> dbRecipes;

  _SearchRecipeState() {
    this.localRecipes = DatabaseProvider.getRecipes();
    this.dbRecipes = DatabaseProvider.getFirebaseRecipes();
  }

  @override
  String get searchFieldLabel => 'Search Recipe...';

  @override
  List<Widget> buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
    return buildList(localRecipes, dbRecipes, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // shows when someone searches for something
    final localRecipesList =
        query.isEmpty ? localRecipes : DatabaseProvider.searchRecipes(query);

    final databaseRecipesList = query.isEmpty
        ? dbRecipes
        : DatabaseProvider.searchFirebaseRecipes(query);

    return buildList(localRecipesList, databaseRecipesList, context);
  }

  Column buildList(Future<List<Recipe>> localRecipesList,
      Future<List<Recipe>> databaseRecipesList, BuildContext context) {
    return Column(
      children: [
        Header(header: 'MY COOKBOOK'),
        FutureBuilder<List<Recipe>>(
          future: localRecipesList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            return snapshot.hasData
                ? ListView(
                    shrinkWrap: true,
                    children: snapshot.data
                        .map((recipe) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/view-recipe',
                                  arguments: recipe,
                                );
                              },
                              child: RecipeTile(recipe, context),
                            ))
                        .toList())
                : SizedBox();
          },
        ),
        Header(header: 'ALL RECIPES'),
        FutureBuilder<List<Recipe>>(
          future: databaseRecipesList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            return snapshot.hasData
                ? ListView(
                    shrinkWrap: true,
                    children: snapshot.data
                        .map((recipe) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/view-recipe',
                                  arguments: recipe,
                                );
                              },
                              child: RecipeTile(recipe, context),
                            ))
                        .toList())
                : SizedBox();
          },
        ),
      ],
    );
  }
}
