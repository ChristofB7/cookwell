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
  Future<List<Recipe>> savedRecipes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    savedRecipes = DatabaseProvider.getRecipes();

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
              SizedBox(
                height: MediaQuery.of(context).size.height/3,
                child: FutureBuilder<List<Recipe>>(
                    future: savedRecipes,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Recipe>> snapshot) {
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
              Header(header: 'ALL RECIPES',),
              SizedBox(
                height: MediaQuery.of(context).size.height/3,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: dummy_recipes
                      .map((recipe) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/view-recipe',
                                arguments: recipe,
                              );
                            },
                            child: RecipeTile(recipe, context),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
