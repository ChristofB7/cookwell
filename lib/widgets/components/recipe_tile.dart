import 'package:cookwell/model/recipe.dart';
import 'package:flutter/material.dart';

class RecipeTile extends StatelessWidget {

  Recipe recipe;
  ColorScheme colorScheme;
  TextTheme textTheme;

  RecipeTile(Recipe recipe, BuildContext context) {
    this.recipe = recipe;
    this.colorScheme = Theme.of(context).colorScheme;
    this.textTheme = Theme.of(context).textTheme;
  }

  @override
  Widget build(BuildContext context) {
    final totalTime = recipe.cookingTime.inMinutes + recipe.prepTime.inMinutes;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: ListTile(
        tileColor: colorScheme.background,
        leading: Container(
          height: 50,
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: FittedBox(child: Image(image: recipe.image.image ?? AssetImage('lib/assets/images/vegetarian.png'),), fit: BoxFit.cover),
          ),
        ),
        title: Text(recipe.name),
        // TODO ADD ICONS
        subtitle: Row(children: [
          Text("total time: $totalTime serving size: ${recipe.servingSize
                  .toStringAsFixed(0)}",
              style: textTheme.caption),
        ]),
      ),
    );
  }
}
