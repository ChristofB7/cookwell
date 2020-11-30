import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/dummy_data.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: colorScheme.surface,
      // TODO refresh page on Navigation pop
      body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: Text("My Cookbook"),
              ), FutureBuilder<List<Recipe>>(
                  future: savedRecipes,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Recipe>> snapshot) {
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
                          child: createRecipeTile(recipe, colorScheme, textTheme),
                        ))
                            .toList())
                        : SizedBox();
                  },
                ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: Text("All Recipes"),
              ),
              ListView(
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
                          child: createRecipeTile(recipe, colorScheme, textTheme),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
    );
  }

  Card createRecipeTile(
      Recipe recipe, ColorScheme colorScheme, TextTheme textTheme) {
    final totalTime = recipe.cookingTime.inMinutes;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: ListTile(
        tileColor: colorScheme.background,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: recipe.image != null ? recipe.image : Image(image: AssetImage('lib/assets/images/vegetarian.png')),
        ),
        title: Text(recipe.name),
        // TODO ? add description
        // TODO TOTAL COOKING TIME = COOKING + PREP TIME
        // TODO ADD ICONS
        subtitle: Row(children: [
          Text(
              "total Time: ${totalTime} serving size: ${recipe.servingSize.toStringAsFixed(0)}",
              style: textTheme.caption),
        ]),
        //trailing: ,
      ),
    );
  }
}
