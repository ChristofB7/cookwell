import 'package:cookwell/model/recipe.dart';
import 'package:flutter/material.dart';

class ViewRecipe extends StatelessWidget {
  Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    recipe = ModalRoute.of(context).settings.arguments as Recipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name,),
        backgroundColor: colorScheme.primary,
      ),
      backgroundColor: colorScheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                ),
                  child: FittedBox(
                    child: recipe.image,
                    fit: BoxFit.fill,
                  ),
                ),
             Text(
                  'Serving Size: ${recipe.servingSize.toStringAsFixed(0)}\n'
                  'Prep Time: ${recipe.prepTime.inMinutes} minutes\n'
                  'Cooking Time: ${recipe.cookingTime.inMinutes} minutes'),
          ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                //width: double.infinity,
                //height: 30,

              decoration: BoxDecoration (
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
    color:colorScheme.surface,
    ),
                child: Text('Ingredients', style: TextStyle(height: 3, fontSize: 10, color: colorScheme.primary),),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.ingredients
                    .map((ingredient) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            ingredient.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              Text('Directions'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.directions
                    .asMap()
                    .entries
                    .map((direction) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '${direction.key + 1}. ${direction.value}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
