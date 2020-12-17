import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:cookwell/widgets/recipe_searchbar.dart';
import 'package:cookwell/interfaces/stateful_menu.dart';
import 'package:cookwell/widgets/components/vertical_recipes_list.dart';
import 'package:flutter/material.dart';


class RecipeMenu extends StatefulWidget {
  @override
  RecipeMenuState createState() => RecipeMenuState();
}

class RecipeMenuState extends StatefulMenu {
  Future<List<Recipe>> localRecipes;
  Future<List<Recipe>> dbRecipes;

  @override
  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    localRecipes = DatabaseProvider.getRecipes();
    dbRecipes = DatabaseProvider.getFirebaseRecipes();

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //TODO Make top bar?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [RecipeSearchBar()],
            ),
            VerticalRecipesList(header: "MY COOKBOOK", list: localRecipes, state: this,),
            VerticalRecipesList(header: "ALL RECIPES", list: dbRecipes, state: this,),
          ],
        ),
      ),
    );
  }
}
