import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:cookwell/widgets/recipe_tile.dart';
import 'package:cookwell/widgets/search_recipe.dart';
import 'package:flutter/material.dart';

import 'header.dart';

class RecipeMenu extends StatefulWidget {
  static _RecipeMenuState refreshMenu() {
    return _RecipeMenuState();
  }

  @override
  _RecipeMenuState createState() => _RecipeMenuState();
}

class _RecipeMenuState extends State<RecipeMenu> {
  Future<List<Recipe>> localRecipes;
  Future<List<Recipe>> dbRecipes;

  _navigateAndDisplaySelection(BuildContext context, Recipe recipe) async {
    final result =
    await Navigator.of(context).pushNamed(
      '/view-recipe',
      arguments: recipe,
    );
    if (result) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    localRecipes = DatabaseProvider.getRecipes();
    dbRecipes = DatabaseProvider.getFirebaseRecipes();

    return Scaffold(
      backgroundColor: colorScheme.background,
      // TODO refresh page on Navigation pop
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TODO : make this into own widget
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [SearchRecipe()],
            ),
            Header(header: 'MY COOKBOOK'),
            FutureBuilder<List<Recipe>>(
              future: localRecipes,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
                //TODO fix async of images
                return snapshot.hasData
                    ? ListView(
                        shrinkWrap: true,
                        children: snapshot.data
                            .map((recipe) => GestureDetector(
                                  onTap: () => _navigateAndDisplaySelection(context, recipe),
                                  child: RecipeTile(recipe, context),
                                ))
                            .toList())
                    : SizedBox();
              },
            ),
            Header(
              header: 'ALL RECIPES',
            ),
            FutureBuilder<List<Recipe>>(
              future: dbRecipes,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
                return snapshot.hasData
                    ? ListView(
                        shrinkWrap: true,
                        children: snapshot.data
                            .map((recipe) => GestureDetector(
                                  child: RecipeTile(recipe, context),
                                  onTap: () => _navigateAndDisplaySelection(context, recipe),
                                ))
                            .toList())
                    : SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
