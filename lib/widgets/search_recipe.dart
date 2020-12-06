import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/dummy_data.dart';
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
          showSearch(
              context: context, delegate: _SearchRecipeState(dummy_recipes));
        });
  }
}

// TODO: search by ingredients
// TODO: search saved recipes & web

class _SearchRecipeState extends SearchDelegate<String> {
  Future<List<Recipe>> localRecipes;
  List<Recipe> dbRecipes;

  _SearchRecipeState(List<Recipe> dbRecipes) {
    this.localRecipes = DatabaseProvider.getRecipes();
    this.dbRecipes = dbRecipes;
  }

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
    final textTheme = Theme.of(context).textTheme;

    return IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          color: colorScheme.primary,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: localRecipes,
      builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
        return snapshot.hasData
            ? Column(
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final localRecipesList = query.isEmpty ? localRecipes : DatabaseProvider.searchRecipes(query);

    final databaseRecipesList = query.isEmpty
        ? dbRecipes
        : dbRecipes
            .where((recipe) =>
                recipe.name.contains(RegExp(query, caseSensitive: false)))
            .toList();

    return buildList(localRecipesList, databaseRecipesList, context);
  }

  Column buildList(Future<List<Recipe>> localRecipesList, List<Recipe> databaseRecipesList, BuildContext context) {
    return Column(
      children: [
        Header(header: 'MY COOKBOOK'),
        SizedBox(
          height: MediaQuery.of(context).size.height/3,
          child: FutureBuilder<List<Recipe>>(
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
        ),
        Header(header: 'ALL RECIPES'),
        SizedBox(
          height: MediaQuery.of(context).size.height/3,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/view-recipe',
                  arguments: databaseRecipesList[index],
                );
              },
              child: RecipeTile(databaseRecipesList[index], context),
            ),
            itemCount: databaseRecipesList.length,
          ),
        ),
      ],
    );
  }
}