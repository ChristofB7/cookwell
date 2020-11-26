import 'package:cookwell/model/dummy_data.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:flutter/material.dart';

class RecipeMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Text("Saved Recipes"),
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
          child: recipe.image,
        ),
        title: Text(recipe.name),
        // TODO ? add description
        // TODO TOTAL COOKING TIME = COOKING + PREP TIME
        // TODO ADD ICONS
        subtitle: Row(children: [
          Text(
              "Total Time: ${totalTime} Serving Size: ${recipe.servingSize.toStringAsFixed(0)}",
              style: textTheme.caption),
        ]),
        //trailing: ,
      ),
    );
  }
}
